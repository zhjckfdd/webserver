module Types.API.CreateNews where

import Control.Monad (mzero)
import Data.Aeson

data CreateNewsReq = CreateNewsReq {shorttitle :: String, category :: String, content :: String, photo :: Int, publishednews :: Bool}

instance FromJSON CreateNewsReq where
  parseJSON (Object json) = do
    shorttitle <- json .: "shorttitle"
    category <- json .: "category"
    content <- json .: "content"
    photo <- json .: "photo"
    publishednews <- json .: "publishednews"
    pure (CreateNewsReq shorttitle category content photo publishednews)
  parseJSON _ = mzero
