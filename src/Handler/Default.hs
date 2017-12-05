{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Default where

import Import
import Database.Persist.Postgresql

getDefaultR :: Handler Html
getDefaultR = do
    defaultLayout $ do
        addStylesheet $ (StaticR css_temp_css)
        $(whamletFile "templates/template.hamlet")