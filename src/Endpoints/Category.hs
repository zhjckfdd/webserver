module Endpoints.Category where

import Auth (auth)
import Control.Applicative
import Control.Monad
import Data.Aeson (decodeStrict, encode)
import Database.PostgreSQL.Simple
import Network.HTTP.Types.Status (status200, status400, status401, status404)
import Network.Wai
import qualified Types.API.CreateCategory as CC
import qualified Types.API.EditCategory as EC
import Types.Categories
import Types.Users

createCategory :: Connection -> Request -> IO Response
createCategory conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      if (admin user) == False
        then pure (responseLBS status404 [] "Not Found")
        else do
          body <- getRequestBodyChunk req
          let parsingResultJSON = decodeStrict body :: Maybe CC.CreateCategoryReq
          case parsingResultJSON of
            Nothing -> pure (responseLBS status400 [] "Bad Request")
            Just createCategoryReq -> do
              let parsedCategoryName = CC.categoryName createCategoryReq
              execute
                conn
                "insert into category (category_name) values (?)"
                [parsedCategoryName]
              pure (responseLBS status200 [] "Success")

getCategories :: Connection -> Request -> IO Response
getCategories conn req = do
  categories <- query_ conn "select * from category" :: IO [EntityCategory]
  let doJson = encode categories
  pure (responseLBS status200 [] doJson)

editCategory :: Connection -> Request -> IO Response
editCategory conn req = do
  authResult <- auth conn req
  case authResult of
    Nothing -> pure (responseLBS status401 [] "Unauthorized")
    Just user -> do
      if (admin user) == False
        then pure (responseLBS status404 [] "Not Found")
        else do
          body <- getRequestBodyChunk req
          let parsingResultJSON = decodeStrict body :: Maybe EC.EditCategoryReq
          case parsingResultJSON of
            Nothing -> pure (responseLBS status400 [] "Bad Request")
            Just editCategoryReq -> do
              let parsedId = EC.categoryId editCategoryReq
              let parsedCategoryName = EC.categoryName editCategoryReq
              category <- query conn "select * from category where id = ?" [parsedId] :: IO [EntityCategory]
              case category of
                [] -> pure (responseLBS status404 [] "Category with such id does not exist")
                (x : _) -> do
                  execute
                    conn
                    "update category set category_name = ? where id = ?"
                    [parsedCategoryName, show parsedId]
                  pure (responseLBS status200 [] "Success")
