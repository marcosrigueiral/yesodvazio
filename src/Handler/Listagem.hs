{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Listagem where

import Import
import Database.Persist.Postgresql

-- SELECT * FROM SERIE
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