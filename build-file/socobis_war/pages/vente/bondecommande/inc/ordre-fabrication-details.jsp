<%--
    Document   : vente-details
    Created on : 22 mars 2024, 17:05:45
    Author     : Angela
--%>


<%@page import="fabrication.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="produits.Ingredients" %>


<%
    try{
        OfFilleCpl t = new OfFilleCpl();
        t.setNomTable("BONDECOMMANDE_OFDETAILS");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = { "idingredients", "libelleexacte","idbc","qte","daty"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));

        if(request.getParameter("id") != null){
            pr.setAWhere(" and idbc='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);
        OfFille[] listeFille=(OfFille[]) pr.getTableau().getData();
        if(listeFille.length>0) {
            Of o = new Of();
            o.setFille(listeFille);
            o.calculerRevient(null);
        }

        String lienTableau[] = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneLien[] = {"idingredients"};
//        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
  //      pr.getTableau().setAttLien(attributLien);

        //pr.getTableau().setData(listeFille);
        pr.getTableau().transformerDataString();
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  { "Composants","D&eacute;signation","Id Bon de Commande","Quantite","Date"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant Revient:</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(listeFille,"montantRevient")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <%  }if(pr.getTableau().getHtml() == null)
    {
    %><center><h4>Aucune donne trouvee</h4></center><%
    }


%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>

