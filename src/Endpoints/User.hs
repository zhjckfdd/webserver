module Endpoints.User where

import Auth (auth)
import Control.Applicative
import Control.Monad
import Data.Aeson (decodeStrict, encode)
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple
import Network.HTTP.Types.Status (status200, status400, status401, status404)
import Network.Wai
import qualified Types.API.CreateUser as API
import qualified Types.API.EditUser as EU
import Types.Users

createUser :: Connection -> Request -> IO Response
createUser conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      if (admin user) == False
        then pure (responseLBS status404 [] "Not Found")
        else do
          body <- getRequestBodyChunk req
          let parsingResultJSON = decodeStrict body :: Maybe API.CreateUserReq
          case parsingResultJSON of
            Nothing -> pure (responseLBS status400 [] "Bad Request")
            Just createUserReq -> do
              let parsedName = API.name createUserReq
              let parsedLogin = API.login createUserReq
              let parsedPass = API.pass createUserReq
              execute
                conn
                "insert into users (name, login, password) values (?,?,?)"
                [parsedName, parsedLogin, parsedPass]
              pure (responseLBS status200 [] "Success")

getUsers :: Connection -> IO Response
getUsers conn = do
  users <- query_ conn "select * from users" :: IO [EntityUser]
  let doJson = encode users
  pure (responseLBS status200 [] doJson)

editUser :: Connection -> Request -> IO Response
editUser conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      body <- getRequestBodyChunk req
      let parsingResultJSON = decodeStrict body :: Maybe EU.EditUserReq
      case parsingResultJSON of
        Nothing -> pure (responseLBS status400 [] "Bad Request")
        Just editUserReq -> do
          let parsedId = EU.id editUserReq
          let parsedName = EU.name editUserReq
          let parsedLogin = EU.login editUserReq
          let parsedPass = EU.pass editUserReq
          users <- query conn "select * from users where id = ?" [parsedId] :: IO [EntityUser]
          case users of
            [] -> pure (responseLBS status404 [] "User with such id does not exist")
            (x : _) -> do
              let updatingName = case parsedName of
                    Nothing -> name x
                    Just name' -> name'
              let updatingLogin = case parsedLogin of
                    Nothing -> login x
                    Just login' -> login'
              let updatingPass = case parsedPass of
                    Nothing -> password x
                    Just pass' -> pass'
              execute
                conn
                "update users set name = ?, login = ?, password = ? where id = ?"
                [updatingName, updatingLogin, updatingPass, show parsedId]
              pure (responseLBS status200 [] "Success")
