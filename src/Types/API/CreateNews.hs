module Types.API.CreateNews where

import Control.Monad (mzero)
import Data.Aeson

data CreateNewsReq = CreateNewsReq {shorttitle :: String, categoryId :: Int, content :: String, photo :: Int, publishednews :: Bool}

instance FromJSON CreateNewsReq where
  parseJSON (Object json) = do
    shorttitle <- json .: "shorttitle"
    categoryId <- json .: "categoryId"
    content <- json .: "content"
    photo <- json .: "photo"
    publishednews <- json .: "publishednews"
    pure (CreateNewsReq shorttitle categoryId content photo publishednews)
  parseJSON _ = mzero
