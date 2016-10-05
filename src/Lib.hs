module Lib
    ( readMessage
    , writeMessage
    ) where
import Data.Binary.Put (runPut,putWord32be)
import Data.Binary.Get (getWord32be,runGet)
import Data.ByteString.Lazy (ByteString,hGet,hPut,pack)
import Data.ByteString.Lazy.Char8 (unpack)
import Data.List
import Data.Word
import System.IO

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

