<%@page import="stock.MvtStockFilleLib"%>
<%@page import="stock.MvtStockFille"%>
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8;" %>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>

<%
    try{
        MvtStockFilleLib t = new MvtStockFilleLib();
        t.setNomTable("MVTSTOCKFILLELIB2");
        String listeCrt[] = {};
        String listeInt[] = {};
        String libEntete[] = {"id", "libelleexacte","idunitelib","Entree","sortie","pu","montant", "compteLocalisationLib","mvtSrc","remarque"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setLien((String) session.getValue("lien"));
        if(request.getParameter("id") != null){
            System.out.println("idmere "+request.getParameter("id"));
            pr.setAWhere(" and idmvtstock='"+request.getParameter("id")+"'");
        }
        String[] colSomme = null;
        pr.creerObjetPage(libEntete, colSomme);
        MvtStockFilleLib[] liste=(MvtStockFilleLib[])pr.getListe();
        String[] lienTableau = { pr.getLien() + "?but=produits/as-ingredients-fiche.jsp", pr.getLien() + "?but=compta/localisation/localisation-fiche.jsp"};
        String[] colonneLien = { "libelleexacte", "compteLocalisationLib" };
        String[] attLien = { "id", "id" };
        String[] valeurLien = { "idProduit", "compteLocalisation" };
%>

<div class="box-body">
    <%
        String libEnteteAffiche[] =  {"Ref", "Produit","Unit&eacute;","Entr&eacute;e","Sortie","Prix unitaire","montant","Emplacement","Mouvement source","Remarque"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attLien);
        pr.getTableau().setValeurLien(valeurLien);
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
        }else
        {
    %><div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
    out.print("<div class=\"col-md-12\" style=\"padding: 16px 8px;text-align: end;align-content: end;\" ><b>Montant Total : "+Utilitaire.formaterAr(AdminGen.calculSommeDouble(liste,"montant"))  +" Ar</b></div>");

%>
</div>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>


