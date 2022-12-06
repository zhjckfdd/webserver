module Types.API.CreateUser where

import Control.Monad (mzero)
import Data.Aeson

--Написать тип, в котором будет указано что я хочу,
--чтобы клиент передавал мне в теле запроса

data CreateUserReq = CreateUserReq {name :: String, login :: String, pass :: String}

instance FromJSON CreateUserReq where
  parseJSON (Object json) = do
    name <- json .: "name"
    login <- json .: "login"
    pass <- json .: "pass"
    pure (CreateUserReq name login pass)
  parseJSON _ = mzero
