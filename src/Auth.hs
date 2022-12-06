module Auth where

import Data.Aeson (encode)
import Data.ByteString (ByteString)
import Data.ByteString.Base64 (decode)
import qualified Data.ByteString.Char8 as BS
import Database.PostgreSQL.Simple (Connection, query)
import Network.HTTP.Types.Header (HeaderName)
import Network.Wai
import Types.Users

auth :: Connection -> Request -> IO (Maybe EntityUser)
auth conn req = do
  let reqHeaders = requestHeaders req
  let parsedHeader = searchAuthorizationHeader reqHeaders
  case parsedHeader of
    Nothing -> pure Nothing
    Just headerValue ->
      if "Basic " `BS.isPrefixOf` headerValue
        then
          let decodeAccPass = decode (BS.drop 6 headerValue)
           in case decodeAccPass of
                Left decodeError -> pure Nothing
                Right accPass -> do
                  let account = BS.takeWhile (/= ':') accPass
                  let password = BS.drop 1 $ BS.dropWhile (/= ':') accPass
                  checkInDB <- query conn "select * from users where login = ? and password = ?" [account, password] :: IO [EntityUser]
                  case checkInDB of
                    [] -> pure Nothing
                    (x : _) -> pure (Just x)
        else pure Nothing

searchAuthorizationHeader :: [(HeaderName, ByteString)] -> Maybe ByteString
searchAuthorizationHeader [] = Nothing
searchAuthorizationHeader (x : xs) =
  if fst x == "Authorization"
    then Just (snd x)
    else searchAuthorizationHeader xs
