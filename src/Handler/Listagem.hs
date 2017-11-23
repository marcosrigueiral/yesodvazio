{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Listagem where

import Import
import Database.Persist.Postgresql

getListagemR :: Handler Html
getListagemR = do
    defaultLayout $ do
        addStylesheet $ (StaticR css_estilos_css)
        addStylesheet $ (StaticR css_estilosMaster_css)
        addStylesheet $ (StaticR css_estilosGeral_css)
        addStylesheet $ (StaticR css_bootstrap_css)
        $(whamletFile "templates/listagem.hamlet")