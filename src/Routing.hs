module Routing where

import Auth (auth)
import Control.Applicative
import Control.Monad
import Data.Aeson (encode)
import Database.PostgreSQL.Simple
import Endpoints.Category (createCategory, editCategory, getCategories)
import Endpoints.News (createNews, deleteNews, editNews, getNews)
import Endpoints.Picture (getPicture)
import Endpoints.User (createUser, editUser, getUsers)
import Network.HTTP.Types (hContentType, status200)
import Network.Wai

application :: Connection -> Application -- Request -> (Response -> IO ResponseReceived) -> IO ResponseReceived
application conn req respond = do
  routing conn req respond

-- Здесь первый аргумент, это тип Request, описывающий запрос,
-- а второй, это “ответчик” - функция, призванная возвращать ответ Response
-- в процессе выполнения некой работы (для этого в типе монада IO).

routing :: Connection -> Application
routing conn req respond = do
  let pathInfo = rawPathInfo req
  case pathInfo of
    "/getUsers" -> do
      response <- getUsers conn
      respond response
    "/createCategory" -> do
      response <- createCategory conn req
      respond response
    "/createUser" -> do
      response <- createUser conn req
      respond response
    "/editUser" -> do
      response <- editUser conn req
      respond response
    "/createNews" -> do
      response <- createNews conn req
      respond response
    "/getNews" -> do
      response <- getNews conn req
      respond response
    "/deleteNews" -> do
      response <- deleteNews conn req
      respond response
    "/editNews" -> do
      response <- editNews conn req
      respond response
    "/editCategory" -> do
      response <- editCategory conn req
      respond response
    -- "/getPicture" -> respond $ getPicture req
    _ ->
      respond $
        responseLBS
          status200
          [(hContentType, "text/plain")]
          "unknown method"

-- printRequest :: Application
-- printRequest req respond = do
--   print (rawPathInfo req)
--   respond $ responseLBS status200
--                 [(hContentType, "text/plain")]
--                 "boka\n"

-- Request {requestMethod = "GET",
--  httpVersion = HTTP/1.1,
--   rawPathInfo = "/",
--    rawQueryString = "",
--     requestHeaders = [("Host","localhost:8000"),("User-Agent","curl/7.68.0"),("Accept","*/*")],
--      isSecure = False,
--       remoteHost = 127.0.0.1:47178,
--        pathInfo = [],
--         queryString = [],
--          requestBody = <IO ByteString>,
--           vault = <Vault>,
--            requestBodyLength = KnownLength 0,
--             requestHeaderHost = Just "localhost:8000",
--              requestHeaderRange = Nothing}
