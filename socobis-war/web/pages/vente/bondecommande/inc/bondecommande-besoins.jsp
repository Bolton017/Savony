<%@page import="produits.Recette"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.*" %>
<%@ page import="vente.BonDeCommande" %>

<%
    BonDeCommande of = new BonDeCommande();
    of.setId(request.getParameter("id"));
    Recette[] recettes = of.decomposer(null);
    Recette r = new Recette();
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"idingredients","libIngredients", "unite", "quantite","qteav","qtetotal"};
    PageRecherche pr = new PageRecherche(r, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    pr.getTableau().setData((bean.ClassMAPTable[]) recettes);
    pr.getTableau().transformerDataString();
 
%>

<div class="box-body">
    <%
        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idingredients"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        String libEnteteAffiche[] =  {"Ref ingr&eacute;dients","Ingr&eacute;dients", "Unit&eacute;", "Qte","PU","Montant"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        Recette[] liste=(Recette[]) pr.getTableau().getData();
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
         %>
        <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant totale : </b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(liste,"qtetotal")) %> Ar</b></td>
            </tr>
        </table>
        </div>
       <%
          } 
        else
            {
               %><center><h4>Aucune donn�e trouv�</h4></center><%
        }
    %>
            
</div>
    
