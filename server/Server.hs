module Main where

import Network.Socket
import System.IO
import Control.Concurrent
import Lib
import System.Environment
import System.Exit

main :: IO ()
main = do
  getArgs >>= parseArgs >>= perform

parseArgs :: [String] -> IO (PortNumber)
parseArgs [port] = return $ (read port)
parseArgs _ = usage >> exit

usage = putStrLn "Usage: server <port>"
exit = exitWith ExitSuccess


perform :: PortNumber -> IO ()
perform port = do
  sock <- socket AF_INET Stream 0
  setSocketOption sock ReuseAddr 1
  bind sock (SockAddrInet port iNADDR_ANY)
  listen sock 2
  mainLoop sock

mainLoop :: Socket -> IO ()
mainLoop  sock = do
  conn <- accept sock
  forkIO (runConn conn)
  mainLoop sock

runConn :: (Socket, SockAddr) -> IO ()
runConn (sock, _) = do
  handle <- socketToHandle sock ReadWriteMode
  hSetBuffering handle NoBuffering
  handleRequest handle reverse
  hClose handle

handleRequest :: Handle -> (String -> String) -> IO ()
handleRequest handle function = do
  hPutStr handle "ready\n"
  message <- readMessage handle
  writeMessage handle (function message)
