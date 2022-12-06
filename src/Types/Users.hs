module Types.Users where

import Data.Aeson
import Data.Time (UTCTime)
import Database.PostgreSQL.Simple.FromRow

data EntityUser = User
  { id :: Int,
    name :: String,
    login :: String,
    password :: String,
    dateOfCreation :: UTCTime,
    admin :: Bool,
    canCreateNews :: Bool
  }
  deriving (Show) -- deriving автоматически пишет instance

instance FromRow EntityUser where
  fromRow = User <$> field <*> field <*> field <*> field <*> field <*> field <*> field

instance ToJSON EntityUser where
  toJSON (User userId userName userLogin _userPwd dateReg isAdmin canCreateNews) =
    object
      [ "id" .= userId,
        "name" .= userName,
        "login" .= userLogin,
        "date_of_creation" .= dateReg,
        "admin" .= isAdmin,
        "canCreateNews" .= canCreateNews
      ]
