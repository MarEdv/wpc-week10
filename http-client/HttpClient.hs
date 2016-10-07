module Main where

import Network
import System.IO
import Lib
import System.Environment
import System.Exit

main :: IO ()
main = withSocketsDo $ do
  getArgs >>= parseArgs >>= perform

parseArgs :: [String] -> IO ((HttpMethod, String, PortID, String))
parseArgs [method, host, port, path] = return $ (read method, host, Service port, path)
parseArgs _ = usage >> exit

usage = putStrLn "Usage: http-client <method> <host> <port> <path>"
exit = exitWith ExitSuccess

perform :: (HttpMethod, String, PortID, String) -> IO ()
perform (method, host, port, path) = do
  handle <- connectTo host port
  (statusLine, headers, contents) <- httpRequest handle method path
  hClose handle
  putStrLn $ "Status line: " ++ statusLine
  logHeaders headers
  logContents contents

logHeaders :: [HttpHeader] -> IO ()
logHeaders headers = do
  putStrLn "\nHeaders"
  mapM_ (\d -> putStrLn ((fst d) ++ ": " ++ (snd d))) headers

logContents :: Maybe String -> IO ()
logContents (Just contents) = do
  putStrLn "\nContents"
  putStrLn "======================================"
  putStrLn contents
  putStrLn "======================================"
logContents Nothing = do
  putStrLn "\nEmpty contents!!"
