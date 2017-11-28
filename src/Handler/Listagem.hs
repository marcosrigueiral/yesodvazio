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
getListagemR = error "undefined" -- do 
--     produtos <- runDB $ selectList [] [Asc ProdutoNome]
--     defaultLayout $ do 
--         [whamlet|
--             <table>
--                 <thead>
--                     <tr>
--                         <th>
--                             Nome
                        
--                         <th> 
--                             Descricao
                        
--                         <th>
--                             Precolista
                        
--                         <th> 
--                             Estoque
                        
--                         <th>
                            
                
--                 <tbody>
--                     $forall (Entity cliid produto) <- produtos
--                         <tr>
--                             <td>
--                                 <a href=@{PerfilSerieR serieid}> 
--                                     #{serieNome serie}
                            
--                             <td>
--                                 #{serieGenero serie}
                            
--                             <td>
--                                 #{serieQtTemp serie}
                            
--                             <td>
--                                 #{serieAno serie}
                            
--                             <td>
--                                 <form action=@{ApagarSerieR serieid} method=post>
--                                     <input type="submit" value="Apagar">
--         |]

-- Usuario json
--     nome      Text
--     cpf       Text 
--     email     Text
--     senha     Text
--     usuid     TipousuarioId
--     UniqueCpf cpf
--     deriving Show

-- SELECT * FROM USUARIO

-- /serie/listar              ListarSerieR     GET
-- /serie/#SerieId/apagar     ApagarSerieR     POST

getPerfilUsuarioR :: UsuarioId -> Handler Html
getPerfilUsuarioR usuarioid = do 
    usuario <- runDB $ get404 usuarioid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Nome: #{usuarioNome usuario}
            <h2>
                CPF: #{usuarioCpf usuario} 
            <h2>
                E-mail: #{usuarioEmail usuario}
            <a href=@{HomeR}> Voltar
        |]

getListarUsuarioR :: Handler Html
getListarUsuarioR = do 
    usuarios <- runDB $ selectList [] [Asc UsuarioNome]
    defaultLayout $ do
        [whamlet| 
            <table>
                <thead>
                    <tr>
                        <th>
                            CPF
                        <th>
                            NOME
                        <th>
                            E-MAIL
                <tbody>
                    $forall (Entity usuarioid usuario) <- usuarios
                        <tr>
                            <td>
                                <a href=@{PerfilUsuarioR usuarioid}> 
                                    #{usuarioNome usuario}
                            
                            <td>
                                #{usuarioCpf usuario}
                            
                            <td>
                                #{usuarioEmail usuario}
                            
                            <td>
                                <form action=@{ExcluirUsuarioR usuarioid} method=post>
                                    <input type="submit" value="Excluir">
        |]

postExcluirUsuarioR :: UsuarioId -> Handler Html
postExcluirUsuarioR usuarioid = do 
    _ <- runDB $ get404 usuarioid
    runDB $ delete usuarioid
    redirect ListarUsuarioR