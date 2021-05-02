module Web.Auth
  ( isUserAuthenticated
  , getUserIdFromSession
  , markUserAsAuthenticated
  , withUserId
  ) where

import Data.UUID (fromText)
import Web.Scotty.Trans (ActionT)

import DB.User (UserId (..))
import Web.Sessions (putAssign, fetchAssign)
import Web.Types (MatchmakerError, WebM)

isUserAuthenticated :: ActionT MatchmakerError WebM Bool
isUserAuthenticated = do
  result <- fetchAssign "authed?"
  if result == Just "true"
  then pure True
  else pure False

markUserAsAuthenticated :: UserId -> ActionT MatchmakerError WebM ()
markUserAsAuthenticated userId =
  putAssign "user_id" (toText userId)

getUserIdFromSession :: ActionT MatchmakerError WebM (Maybe UserId)
getUserIdFromSession = do
  result <- fetchAssign "user_id"
  case result of
    Nothing -> pure Nothing
    Just uuid -> pure $ UserId <$> fromText uuid

withUserId :: (UserId -> ActionT MatchmakerError WebM ())
           -> ActionT MatchmakerError WebM ()
withUserId action = do
  result <- getUserIdFromSession
  whenJust result action
