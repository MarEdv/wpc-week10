module Main where

import Network
import System.IO
import Lib
import System.Environment
import System.Exit

main :: IO ()
main = withSocketsDo $ do
  getArgs >>= parseArgs >>= perform

parseArgs :: [String] -> IO ((String, PortID))
parseArgs [host, port] = return $ (host, Service port)
parseArgs _ = usage >> exit

usage = putStrLn "Usage: client <host> <port>"
exit = exitWith ExitSuccess

perform :: (String, PortID) -> IO ()
perform (host, port) = do
  handle <- connectTo host port
  sendRequest handle
  hClose handle

sendRequest :: Handle -> IO ()
sendRequest handle = do
  output <- hGetLine handle
  let text = "Hello, Server!"
  writeMessage handle text
  message <- readMessage handle
  putStrLn message
