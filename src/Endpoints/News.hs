module Endpoints.News where

import Auth (auth)
import Control.Applicative
import Control.Monad
import Data.Aeson (decodeStrict, encode)
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple
import Network.HTTP.Types.Status (status200, status400, status401, status404)
import Network.Wai
import qualified Types.API.CreateNews as API
import qualified Types.API.DeleteNews as DN
import qualified Types.API.EditNews as EN
import Types.News
import qualified Types.Users as TU
import Prelude hiding (id)

createNews :: Connection -> Request -> IO Response
createNews conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      if (TU.canCreateNews user) == False
        then pure (responseLBS status404 [] "Not Found")
        else do
          body <- getRequestBodyChunk req
          let parsingResultJSON = decodeStrict body :: Maybe API.CreateNewsReq
          case parsingResultJSON of
            Nothing -> pure (responseLBS status400 [] "Bad Request")
            Just createNewsReq -> do
              let parsedTitle = API.shorttitle createNewsReq
              let parsedCreatorNews = TU.id user
              let parsedCategory = API.category createNewsReq
              let parsedContent = API.content createNewsReq
              let parsedPhoto = API.photo createNewsReq
              let parsedPublishedNews = API.publishednews createNewsReq
              execute
                conn
                "insert into news (shorttitle, creatornews, category, content, photo, publishednews) values (?,?,?,?,?,?)"
                [parsedTitle, (show parsedCreatorNews), parsedCategory, parsedContent, (show parsedPhoto), (show parsedPublishedNews)]
              pure (responseLBS status200 [] "Success")

getNews :: Connection -> Request -> IO Response
getNews conn req = do
  news <- query_ conn "select * from news" :: IO [EntityNews]
  let doJson = encode news
  pure (responseLBS status200 [] doJson)

deleteNews :: Connection -> Request -> IO Response
deleteNews conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      body <- getRequestBodyChunk req
      let parsingResultJSON = decodeStrict body :: Maybe DN.DeleteNewsReq
      case parsingResultJSON of
        Nothing -> pure (responseLBS status400 [] "Bad Request")
        Just deleteNewsReq -> do
          let parsedId = DN.id deleteNewsReq
          news <- query conn "select * from news where id = ?" [parsedId] :: IO [EntityNews]
          case news of
            [] -> pure (responseLBS status404 [] "News with such id does not exist")
            (x : _) -> do
              if (creatorId x) == (TU.id user)
                then do
                  execute conn "delete from news where id = ?" [parsedId]
                  pure (responseLBS status200 [] "Success")
                else pure (responseLBS status400 [] "Bad Request")

editNews :: Connection -> Request -> IO Response
editNews conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      body <- getRequestBodyChunk req
      let parsingResultJSON = decodeStrict body :: Maybe EN.EditNewsReq
      case parsingResultJSON of
        Nothing -> pure (responseLBS status400 [] "Bad Request")
        Just editNewsReq -> do
          let parsedId = EN.id editNewsReq
          let parsedTitle = EN.shorttitle editNewsReq
          let parsedCategory = EN.category editNewsReq
          let parsedContent = EN.content editNewsReq
          let parsedPhoto = EN.photo editNewsReq
          news <- query conn "select * from news where id = ?" [parsedId] :: IO [EntityNews]
          case news of
            [] -> pure (responseLBS status404 [] "News with such id does not exist")
            (x : _) -> do
              let updatingTitle = case parsedTitle of
                    Nothing -> shortTitle x
                    Just title -> title
              let updatingCategory = case parsedCategory of
                    Nothing -> category x
                    Just category' -> category'
              let updatingContent = case parsedContent of
                    Nothing -> content x
                    Just content' -> content'
              let updatingPhoto = case parsedPhoto of
                    Nothing -> photo x
                    Just photo' -> photo'
              execute
                conn
                "update news set shorttitle = ?, category = ?, content = ?, photo = ? where id = ?"
                [updatingTitle, updatingCategory, updatingContent, (show updatingPhoto), (show parsedId)]
              pure (responseLBS status200 [] "Success")
