{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Home where

import Yesod
import Import
-- import Network.HTTP.Types.Status
-- import Database.Persist.Postgresql


-- estou chamando além dos estilos master e geral o estilos.cc e o bootstrap
getHomeR :: Handler Html
getHomeR = do
    usuariologado <- lookupSession "_ID"
    defaultLayout $ do 
        -- toWidgetHead $ $(juliusFile "templates/home.julius")
        addStylesheet $ (StaticR css_estilos_css)
        addStylesheet $ (StaticR css_estilosMaster_css)
        addStylesheet $ (StaticR css_estilosGeral_css)
        addStylesheet $ (StaticR css_bootstrap_css)
        $(whamletFile "templates/cadastro.hamlet")
        -- $(whamletFile "templates/cadastro.hamlet")
        -- $(whamletFile "templates/listagem.hamlet")