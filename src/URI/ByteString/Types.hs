{-# LANGUAGE DeriveDataTypeable         #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module URI.ByteString.Types where

-------------------------------------------------------------------------------
import           Data.ByteString (ByteString)
import           Data.Monoid
import           Data.Typeable
import           Data.Word
import           GHC.Generics
-------------------------------------------------------------------------------


-- | Required first component to referring to a specification for the
-- remainder of the URI's components, e.g. "http" or "https"
newtype Scheme = Scheme { _schemeBS :: ByteString }
  deriving (Show, Eq, Generic, Typeable)


-------------------------------------------------------------------------------
newtype Host = Host { _hostBS :: ByteString }
  deriving (Show, Eq, Generic, Typeable)


-------------------------------------------------------------------------------
-- | While some libraries have chosen to limit this to a Word16, the
-- spec only specifies that the string be comprised of digits.
newtype Port = Port { _portNumber :: Int }
  deriving (Show, Eq, Generic, Typeable)


-------------------------------------------------------------------------------
data Authority = Authority {
      _authorityUserInfo :: Maybe UserInfo
    , _authorityHost     :: Host
    , _authorityPort     :: Maybe Port
    } deriving (Show, Eq, Generic, Typeable)


-------------------------------------------------------------------------------
data UserInfo = UserInfo {
      _uiUsername :: ByteString
    , _uiPassword :: ByteString
    } deriving (Show, Eq, Generic, Typeable)


-------------------------------------------------------------------------------
newtype Query = Query { _queryPairs :: [(ByteString, ByteString)] }
              deriving (Show, Eq, Monoid)


-------------------------------------------------------------------------------
data URI = URI {
      _uriScheme    :: Scheme
    , _uriAuthority :: Maybe Authority
    , _uriPath      :: ByteString
    , _uriQuery     :: Query
    , _uriFragment  :: Maybe ByteString
    -- ^ URI fragment. Does not include the #
    } deriving (Show, Eq, Generic, Typeable)



-------------------------------------------------------------------------------
-- | Options for the parser. You will probably want to use either
-- "strictURIParserOptions" or "laxURIParserOptions"
data URIParserOptions = URIParserOptions {
      _upoValidQueryChar :: Word8 -> Bool
    }



-------------------------------------------------------------------------------
-- | URI Parser Types
-------------------------------------------------------------------------------


data SchemaError = NonAlphaLeading -- ^ Scheme must start with an alphabet character
                 | InvalidChars    -- ^ Subsequent characters in the schema were invalid
                 | MissingColon    -- ^ Schemas must be followed by a colon
                 deriving (Show, Eq, Read, Generic, Typeable)


-------------------------------------------------------------------------------
data URIParseError = MalformedScheme SchemaError
                   | MalformedUserInfo
                   | MalformedQuery
                   | MalformedFragment
                   | MalformedHost
                   | MalformedPort
                   | MalformedPath
                   | OtherError String -- ^ Catchall for unpredictable errors
                   deriving (Show, Eq, Generic, Read, Typeable)
