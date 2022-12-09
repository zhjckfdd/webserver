module Types.API.EditNews where

import Control.Monad (mzero)
import Data.Aeson

data EditNewsReq = EditNewsReq
  { id :: Int,
    shorttitle :: Maybe String,
    category :: Maybe Int,
    content :: Maybe String,
    photo :: Maybe Int
  }

instance FromJSON EditNewsReq where
  parseJSON (Object json) = do
    id <- json .: "id"
    shorttitle <- json .:? "shorttitle"
    category <- json .:? "category"
    content <- json .:? "content"
    photo <- json .:? "photo"
    pure (EditNewsReq id shorttitle category content photo)
  parseJSON _ = mzero
