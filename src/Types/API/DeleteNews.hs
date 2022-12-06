module Types.API.DeleteNews where

import Control.Monad (mzero)
import Data.Aeson

data DeleteNewsReq = DeleteNewsReq {id :: Int}

instance FromJSON DeleteNewsReq where
  parseJSON (Object json) = do
    id <- json .: "id"
    pure (DeleteNewsReq id)
  parseJSON _ = mzero
