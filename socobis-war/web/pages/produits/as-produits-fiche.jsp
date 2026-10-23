<%-- 
    Document   : as-produits-fiche
    Created on : 1 d�c. 2016, 10:40:08
    Author     : Joe
--%>

<%@page import="service.AlloSakafoService"%>
<%@page import="java.util.HashMap"%>
<%@page import="mg.allosakafo.produits.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@page import="mg.allosakafo.produits.ProduitsLibelle"%>
<%
    UserEJB u=(user.UserEJB) session.getValue("u");
    ProduitsLibelle a = new ProduitsLibelle();
    a.setIdpoint(AlloSakafoService.getNomRestau());
    a.setNomTable("disponibilite_produit");
    
    PageConsulte pc = pc = new PageConsulte(a, request,u );//ou avec argument liste Libelle si besoin

    pc.getChampByName("id").setLibelle("ID");
    pc.getChampByName("pu").setLibelle("Prix Unitaire");
    pc.getChampByName("calorie").setLibelle("Disponibilite");
    pc.getChampByName("idpoint").setVisible(false);
    pc.getChampByName("pa").setVisible(false);    
    pc.getChampByName("pointindisp").setVisible(false);

    pc.setTitre("Consultation produits");

    RecetteLib recette = new RecetteLib();
    
    ProduitsLibelle base=(ProduitsLibelle)(pc.getBase());
    RecetteLib[] liste =base.getRecette(null,null);
    
    Recette[]listeBase=base.decomposerBase(null);
    double montantTotal=AdminGen.calculSommeDouble(listeBase, "qtetotal");

    boolean isDG=false;
    if(u.getUser().isSuperUser()) isDG=true;
%>
<div class="content-wrapper">
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-produits-liste.jsp"><i class="fa fa-arrow-circle-left"></i></a><%=pc.getTitre()%></h1>
                    </div>
                    <div class="box-body">
                        <%
                            out.println(pc.getHtml());
                        %>
                        <br/>
                        <div class="box-footer">
                            <% if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola")) { %>
                                <a class="btn btn-warning pull-left"  href="<%=(String) session.getValue("lien") + "?but=produits/as-produits-modif.jsp&id=" + request.getParameter("id")%>" style="margin-right: 10px">Modifier</a>
                          <%  } %>
                            <a class="btn btn-danger pull-left"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=dupliquer&id=" + request.getParameter("id")%>&classe=mg.allosakafo.produits.Produits&bute=produits/as-produits-fiche.jsp" style="margin-right: 10px">Dupliquer</a>
                            <a class="btn btn-danger pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=disponiple&isdispo=false&id=" + request.getParameter("id")%>" style="margin-right: 10px">Non disponible</a>
                            <a class="btn btn-success pull-right"  href="<%=(String) session.getValue("lien") + "?but=apresTarif.jsp&acte=disponiple&isdispo=true&id=" + request.getParameter("id")%>" style="margin-right: 10px">Disponible</a>
                             <% if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola")){ %>
                            <a class="btn btn-success pull-right"  href="<%=(String) session.getValue("lien") + "?but=produits/recette-saisie.jsp&idproduit=" + request.getParameter("id")%>" style="margin-right: 10px">Ajouter recette</a>
                            <%}%>
                        </div>
                        <br/>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <% if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola")){ %>
    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <form action="module.jsp?but=apresTarif.jsp" method="post" >
                <div class="box-fiche">
                    <div class="box">
                        <div class="box-title with-border">
                            <h1 class="box-title">Ajout recette</h1>
                        </div>
                        <div class="box-body">

                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Idproduit</th>
                                        <th colspan="2" >Ingredient</th>
                                        <th>Quantit&eacute;</th>
                                        
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td  align="center"><input name="idproduits" type="hidden" value="<%=request.getParameter("id")%>"><%=request.getParameter("id")%></td>
                                        <td  align="center">
                                            <input name="idingredientslibelle" type="textbox" class="form-control" id="idingredientslibelle" value="" tabindex="2" readonly ><input type="hidden" value="" name="idingredients" id="idingredients">                                        
                                        </td>
                                        <td>
                                            <input name="choix" type="button" class="submit" onclick="pagePopUp('choix/listeIngredientChoix.jsp?champReturn=idingredients;idingredientslibelle&amp;apresLienPageAppel=')" value="...">
                                        </td>
                                        <td width="14%" align="center">
                                            <input name="quantite" type="textbox" class="form-control" id="quantite" value="0" onblur="calculer('quantite')" tabindex="3">
                                        </td>
                                        
                                    </tr>
                                </tbody>
                            </table>

                            <input name="acte" type="hidden" id="nature" value="insert">
                            <input name="bute" type="hidden" id="bute" value="produits/as-produits-fiche.jsp&id=<%=request.getParameter("id")%>">
                            <input name="classe" type="hidden" id="classe" value="mg.allosakafo.produits.Recette">
                        </div>                      
                        <div class="box-footer">
                            <button type="submit" name="Submit2" class="btn btn-success pull-right" style="margin-right: 25px;">Ajouter ligne</button>
                        </div>


                    </div>
                </div>
            </form>
        </div>  
    </div>                   
    <% } %>








    <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title">D&eacute;tails Recettes</h1>
                    </div>
                    <form action="<%=(String) session.getValue("lien")%>?but=modifierEtatMultiple.jsp" method="post" name="incident" id="incident">
                        <div class="box-body table-responsive">
                            <input type="hidden" name="bute" value="produits/as-produits-fiche.jsp&id=<%=request.getParameter("id")%>"/>
                            
                            <% if(u.getUser().getLoginuser().equalsIgnoreCase("narindra") || u.getUser().getLoginuser().equalsIgnoreCase("Baovola")){ %>
                            <button type="submit" name="acte" value="modifier_recette" class="btn btn-success pull-right" style="margin-right: 25px;" >Modifier</button> 
                            <button type="submit" name="acte" value="supprimer_recette" class="btn btn-danger pull-left" style="margin-right: 25px;" >Supprimer</button> 
                            <%  } %>
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th align="center" valign="top" style="background-color:#bed1dd">
                                            <input onclick="CocheToutCheckbox(this, 'id')" type="checkbox">
                                        </th>
                                        <th> Id</th>
                                        <th>Ingredient</th>
                                        <th>Quantit&eacute;</th>
                                        <th>Prix unitaire</th>
                                        <th>Unit&eacute;</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%
                                        for (int i = 0; i < liste.length; i++) {
                                    %>
                                    <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                        <td align="center">
                                            <input type="checkbox" value="<%=liste[i].getId()%>-<%=i%>" name="id" id="checkbox0">
                                        </td>
                                        
                                        <td  align="center"><%=liste[i].getId()%></td>
                                        <td  align="center"><a href="<%=(String) session.getValue("lien")%>?but=produits/as-ingredients-fiche.jsp&id=<%=liste[i].getIdingredients()%>"><%=liste[i].getLibelleingredient()%></a></td>
                                        <td width="14%" align="center"><input type="text" id="quantite<%=i%>" name="quantite" value="<%=liste[i].getQuantite()%>" <%= !isDG?"readonly":""  %> ></td>
                                        <td  align="right"><%=Utilitaire.formaterAr(liste[i].getPu())%></td>
                                        <td  align="right"><%=liste[i].getValunite()%></td>
                                    </tr>
                                    <%
                                        }
                                    %>

                                </tbody>
                            </table>

                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
                                    
   <div class="row">
        <div class="col-md-3"></div>
        <div class="col-md-6">
            <div class="box-fiche">
                <h3> Total : <%=Utilitaire.formaterAr(montantTotal) %></h3>
                <div class="box">
                    <div class="box-title with-border">
                        <h1 class="box-title">Decomposition Recettes</h1>
                    </div>
                        <div class="box-body table-responsive">
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        
                                        <th>Ingredient</th>
                                        <th>Quantit&eacute;</th>
                                        <th>Unit&eacute;</th>
                                        <th>Prix Unitaire</th>
                                         <th>Montant</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <%
                                        for (int i = 0; i < listeBase.length; i++) {
                                    %>
                                    <tr onmouseover="this.style.backgroundColor = '#EAEAEA'" onmouseout="this.style.backgroundColor = ''">
                                        
                                        
                                        
                                        <td  align="center"><%=listeBase[i].getIdingredients()%></td>
                                         <td  align="right"><%=listeBase[i].getQuantite() %></td>
                                        <td  align="right"><%=listeBase[i].getIdproduits() %></td>
                                        <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQteav()) %></td>
                                         <td  align="right"><%=Utilitaire.formaterAr(listeBase[i].getQtetotal()) %></td>
                                    </tr>
                                    <%
                                        }
                                    %>

                                </tbody>
                            </table>

                        </div>
                    
                </div>
            </div>
        </div>
    </div>                                 
                                    
</div>