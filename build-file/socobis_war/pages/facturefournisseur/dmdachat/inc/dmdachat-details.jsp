<%@page import="mg.cnaps.compta.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="faturefournisseur.DmdAchatFilleLib" %>

<%
    try{
        DmdAchatFilleLib t = new DmdAchatFilleLib();
        String[] listeCrt = {};
        String[] listeInt = {};
        String[] libEntete = {"idproduit","designation","quantite","unite","pu","remarque"};
        PageRecherche pr = new PageRecherche(t, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
        pr.setUtilisateur((user.UserEJB) session.getValue("u"));
        pr.setAWhere(" AND idmere='"+request.getParameter("id")+"'");
        pr.setLien((String) session.getValue("lien"));
        String[] colSomme = null;
        //pr.setNpp(10);
        pr.creerObjetPage(libEntete, colSomme);

        String[] lienTableau = {pr.getLien() + "?but=produits/as-ingredients-fiche.jsp"};
        String colonneModal[] = {"idproduit"};
        String[] colonneLien = {"idproduit"};
        String[] attributLien = {"id"};
        pr.getTableau().setLien(lienTableau);
        pr.getTableau().setColonneLien(colonneLien);
        pr.getTableau().setAttLien(attributLien);
        pr.getTableau().setModalOnClick(true,colonneModal);
%>

<div class="box-body">
    <%
        String[] libEnteteAffiche =  {"Id produit","D&eacute;signation","Quantit&eacute;","Unit&eacute;","Prix unitaire","Remarque"};
        pr.getTableau().setLibelleAffiche(libEnteteAffiche);
        if(pr.getTableau().getHtml() != null){
            out.println(pr.getTableau().getHtml());
    %>
    <div class="w-100" style="display: flex; flex-direction: row-reverse;">
        <table style="width: 20%"class="table">
            <tr>
                <td><b>Montant Total :</b></td>
                <td><b><%=utilitaire.Utilitaire.formaterAr(AdminGen.calculSommeDouble(pr.getTableau().getData(),"montantTotal")) %> Ar</b></td>
            </tr>
        </table>
    </div>
    <% }if(pr.getTableau().getHtml() == null){ %>
        <div style="text-align: center;"><h4>Aucune donnée trouvée</h4></div><%
    }
%>
</div>
<%=pr.getModalHtml("modalContent")%>
<%
    } catch (Exception e) {
        e.printStackTrace();
    }%>