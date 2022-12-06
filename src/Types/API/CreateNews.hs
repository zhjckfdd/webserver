module Types.API.CreateNews where

import Control.Monad (mzero)
import Data.Aeson

data CreateNewsReq = CreateNewsReq {shorttitle :: String, creatornews :: Int, category :: String, content :: String, photo :: Int, publishednews :: Bool}

instance FromJSON CreateNewsReq where
  parseJSON (Object json) = do
    shorttitle <- json .: "shorttitle"
    creatornews <- json .: "creatornews"
    category <- json .: "category"
    content <- json .: "content"
    photo <- json .: "photo"
    publishednews <- json .: "publishednews"
    pure (CreateNewsReq shorttitle creatornews category content photo publishednews)
  parseJSON _ = mzero
