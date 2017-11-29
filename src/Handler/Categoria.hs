{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Categoria where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Categorias
formCategoria :: Form Categoria
formCategoria = renderDivs $ Categoria
    <$> areq textField     "Descrição: "  Nothing
    
-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Usuarios
getCategoriaR :: Handler Html
getCategoriaR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Categorias
            <ul>
                <li> <a href=@{CadastrarCategoriaR}>  Cadastrar Categorias
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de Categorias utilizando o form criado acima
getCadastrarCategoriaR :: Handler Html
getCadastrarCategoriaR = do 
    (widget,enctype) <- generateFormPost formCategoria
    defaultLayout $ do
        [whamlet|
            <form action=@{CadastrarCategoriaR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

-- inclusao do formulario preenchido no banco
postCadastrarCategoriaR :: Handler Html
postCadastrarCategoriaR = do 
    ((res,_),_) <- runFormPost formCategoria
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect CategoriaR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarCategoriaR
 
getListarCategoriaR :: Handler Html
getListarCategoriaR = do 
    categorias <- runDB $ selectList [] [Asc CategoriaDescricao]
    defaultLayout $ do
        [whamlet| 
            <table>
                <thead>
                    <tr>
                        <th>
                            DESCRICAO
                <tbody>
                    $forall (Entity categoriaid categoria) <- categorias
                        <tr>
                            <td>
                                <a href=@{PerfilCategoriaR categoriaid}> 
                                    #{categoriaDescricao categoria}
                            
                            <td>
                                <form action=@{ExcluirCategoriaR categoriaid} method=post>
                                    <input type="submit" value="Excluir">
        |]
        
getPerfilCategoriaR :: CategoriaId -> Handler Html
getPerfilCategoriaR categoriaid = do 
    categoria <- runDB $ get404 categoriaid
    defaultLayout $ do 
        [whamlet|
            <h1> ]
                Descrição: #{categoriaDescricao categoria}
            <a href=@{HomeR}> Voltar
        |]

postExcluirCategoriaR :: CategoriaId -> Handler Html
postExcluirCategoriaR categoriaid = do 
    _ <- runDB $ get404 categoriaid
    runDB $ delete categoriaid
    redirect ListarCategoriaR