module Main where

import Control.Applicative
import Control.Monad
import Database.PostgreSQL.Simple
import Network.Wai.Handler.Warp (run)
import Routing (application)

main :: IO ()
main = do
  conn <- connectDataBase
  putStrLn "Serving..."
  run 8000 (application conn)

-- run передаёт недостающие аргументы в application (req и respond)

connectDataBase :: IO Connection
connectDataBase =
  connect
    defaultConnectInfo
      { connectHost = "localhost",
        connectPort = 5432,
        connectUser = "shternritter",
        connectPassword = "12345",
        connectDatabase = "webserver"
      }
