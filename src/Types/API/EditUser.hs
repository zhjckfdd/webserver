module Types.API.EditUser where

import Control.Monad (mzero)
import Data.Aeson

data EditUserReq = EditUserReq
  { id :: Int,
    name :: Maybe String,
    login :: Maybe String,
    pass :: Maybe String
  }

instance FromJSON EditUserReq where
  parseJSON (Object json) = do
    id <- json .: "id"
    name <- json .:? "name"
    login <- json .:? "login"
    pass <- json .:? "pass"
    pure (EditUserReq id name login pass)
  parseJSON _ = mzero
