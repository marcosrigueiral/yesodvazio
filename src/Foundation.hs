{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkMessage "App" "messages" "pt-BR"

mkYesodData "App" $(parseRoutesFile "config/routes")

type Form a = Html -> MForm Handler (FormResult a, Widget)
-- type Form a = FormInput Handler a StaticR             

-- LoginR              
-- LogoutR             
-- ListagemR           
-- UsuarioR            
-- CadastrarUsuarioR   
-- PerfilUsuarioR      
-- ListarUsuarioR	    
-- BuscarUsuarioR	    
-- EditarUsuarioR	    
-- ExcluirUsuarioR	    
-- ClienteR            
-- CadastrarClienteR   
-- ListarClienteR      
-- BuscarClienteR      
-- EditarClienteR      
-- ExcluirClienteR     
-- FornecedorR         
-- CadastrarFornecedorR
-- PerfilFornecedorR   
-- ListarFornecedorR   
-- BuscarFornecedorR   
-- EditarFornecedorR   
-- ExcluirFornecedorR  
-- ProdutoR            
-- CadastrarProdutoR   
-- ListarProdutoR      
-- BuscarProdutoR      
-- EditarProdutoR      
-- ApagarProdutoR      
-- PerfilProdutoR      
-- PedidoR             
-- CadastrarPedidoR    
-- ListarPedidoR       
-- BuscarPedidoR       
-- EditarPedidoR       
-- ExcluirPedidoR      
-- CategoriaR          
-- CadastrarCategoriaR 
-- ListarCategoriaR    
-- PerfilCategoriaR    
-- ExcluirCategoriaR   

-- isAuthorized EditarPedidoR _ = ehUsuario

instance Yesod App where
    makeLogger = return . appLogger
    authRoute _ = Just $ HomeR
    isAuthorized (StaticR _) _ = return Authorized
    isAuthorized HomeR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized LogoutR _ = return Authorized
    isAuthorized CadastroR _ = return Authorized
    isAuthorized CadastrarUsuarioR _ = ehAdmin
    isAuthorized CadastrarCategoriaR _ = ehAdmin
    isAuthorized CadastrarFornecedorR _ = ehAdmin
    isAuthorized _ _ = ehUsuario

ehAdmin :: Handler AuthResult
ehAdmin = do
    sessao <- lookupSession "_ID"
    case sessao of 
        Nothing -> return AuthenticationRequired
        (Just "admin") -> return Authorized
        (Just _ ) -> return $ Unauthorized "Você não tem permissão!!!"
    
ehUsuario :: Handler AuthResult
ehUsuario = do
    sessao <- lookupSession "_ID"
    case sessao of 
        Nothing -> return AuthenticationRequired
    -- (Just "admin") -> return $ Unauthorized "ADMIN N FAZ COISA NORMAL" 
        (Just _) -> return Authorized


instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager
