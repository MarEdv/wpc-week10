module Lib
    ( readMessage
    , writeMessage
    , httpRequest
    , HttpMethod
    , HttpHeader
    ) where
import Data.Binary.Put (runPut,putWord32be)
import Data.Binary.Get (getWord32be,runGet)
import Data.ByteString.Lazy (ByteString,hGet,hPut,pack)
import Data.ByteString.Lazy.Char8 (unpack)
import Data.List
import Data.Word
import System.IO
import Data.List.Split

readMessage :: Handle -> IO (String)
readMessage handle = do
  bytes <- hGet handle 4
  let contentLength = runGet getWord32be bytes
  bytes <- hGet handle (fromIntegral contentLength)
  return $ unpack bytes

writeMessage :: Handle -> String -> IO ()
writeMessage handle message = do
  hPut handle (runPut (putWord32be (genericLength message)))
  hPutStr handle message

data HttpMethod = GET
  deriving (Show, Eq, Read)

type HttpHeader = (String, String)

httpRequest :: Handle -> HttpMethod -> String -> IO (String, [HttpHeader], Maybe String)
httpRequest handle method path = do
  hPutStr handle (show method ++ " " ++ path ++ " HTTP/1.0\n\n")
  statusLine <- hGetLine handle
  headers <- getHeaders handle []
  let contentLength = getContentLength headers
  body <- getContentsMaybe handle contentLength
  return (statusLine, headers, body)

getContentsMaybe :: Handle -> Maybe Int -> IO (Maybe String)
getContentsMaybe handle contentLength =
  case contentLength of
    Just length -> do
       s <- hGet handle length
       return $ Just (unpack s)
    Nothing ->
      return Nothing

getContentLength :: [HttpHeader] -> Maybe Int
getContentLength headers = contentLength where
  headerList = filter (\d -> fst d == "Content-Length") headers
  contentLength =
    if length headerList >= 1
      then Just (read $ snd $ head headerList)
      else Nothing

getHeaders :: Handle -> [HttpHeader] -> IO ([HttpHeader])
getHeaders handle headers = do
  line <- hGetLine handle
  if (length line == 1) --why does the line contain a character, should it not be empty? 
    then
      return $ headers
    else
      do
        let splits = splitOn ": " line
        let header = head splits
        let value = head $ tail splits
        hs <- getHeaders handle ([(header, value)] ++ headers)
        return $ hs
