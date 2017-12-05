{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}

module Handler.Pedido where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- Pedido json
--     cliid          ClienteId
--     endid          EnderecoId
--     proid          ProdutoId     
--     formapagid     FormapagamentoId
--     dataPedido     DayformPedido :: Form Pedido

-- formulário de cadastro de Pedidos
formPedido :: Form Pedido
formPedido = renderDivs $ Pedido
    <$> areq textField FieldSettings{fsId=Just "txtPedido",
                                     fsLabel="Pedido: ",
                                     fsTooltip= Nothing,
                                     fsName= Nothing,
                                     fsAttrs=[("class","form-control")]} Nothing
    <*> areq textField FieldSettings{fsId=Just "txtCliente",
                                      fsLabel="Cliente: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] produtoNome) FieldSettings{fsId=Just "txtProduto",
                                      fsLabel="Produto: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq (selectField $ optionsPersistKey [] [] formapagamentoDescricao) FieldSettings{fsId=Just "txtFormapagamento",
                                      fsLabel="Forma de Pagamento: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    <*> areq dayField FieldSettings{fsId=Just "txtDataPedido",
                                      fsLabel="Data Pedido: ",
                                      fsTooltip= Nothing,
                                      fsName= Nothing,
                                      fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq textField FieldSettings{fsId=Just "txtCodigo",
    --                                   fsLabel="Código: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq doubleField FieldSettings{fsId=Just "txtCusto",
    --                                   fsLabel="Custo: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq doubleField FieldSettings{fsId=Just "txtPreco",
    --                                   fsLabel="Preço: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq intField FieldSettings{fsId=Just "txtEstoque",
    --                                   fsLabel="Estoque: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing
    -- <*> areq (selectField $ optionsPersistKey [] [] fornecedorNome) FieldSettings{fsId=Just "txtFornecedor",
    --                                   fsLabel="Fornecedor: ",
    --                                   fsTooltip= Nothing,
    --                                   fsName= Nothing,
    --                                   fsAttrs=[("class","form-control")]} Nothing

-- getFuncionarioR :: Handler TypedContent
-- getFuncionarioR = do
--     funcionario <- (runDB $ selectList [FuncionarioExcluido ==. False][Asc FuncionarioNome]) :: Handler [Entity Funcionario]
--     sendStatusJSON created201 $ object["Funcionario" .= funcionario]

-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de Pedidos
getPedidoR :: Handler Html
getPedidoR = do
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
        |]
        [whamlet|
            <h1> Pedido
            <ul>
                <li> <a href=@{CadastrarPedidoR}>  Cadastrar Pedidos
                <li> <a href=@{ListarPedidoR}>  Listar Pedidos
                <li> <a href=@{HomeR}>  Home
        |]

