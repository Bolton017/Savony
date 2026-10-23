
<%@page import="vente.*"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.*" %>

<%
    Carton  bc = new Carton ();
    bc.setNomTable("CARTON");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id","idBC","dateCreation","remarque", "numero"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and idbc ='"+request.getParameter("id")+"' ");
    pr.getApres();
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
 
    String libEnteteAffiche[] =  {"ID","Bon de commande","Date","Remarque", "Num&eacute;ro"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    String lienTableau[] = {pr.getLien() + "?but=vente/miseencarton/carton-fiche.jsp"};
    String colonneLien[] = {"id"};
    pr.getTableau().setLien(lienTableau);
    pr.getTableau().setColonneLien(colonneLien);

    pr.getTableau().setNameBoutton("Livrer");
    pr.getTableau().setLienFille("vente/miseencarton/inc/carton-details.jsp&id=");

    if(pr.getTableau().getHtmlWithCheckbox() != null){%>
    <div class="box-body">
       <form action="<%=pr.getLien()%>?but=bondelivraison-client/bondelivraison-client-saisie.jsp" id='modif-form' method="post" data-parsley-validate>
            <input name="acte" type="hidden" id="acte" value="miseencarton">
            <input name="idbc" type="hidden" id="idbc" value="<%=request.getParameter("id")%>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
            <input name="ids" type="hidden" id="ids" value="<%= request.getParameter("ids")%>">
            <div class="result mt-5 table-result">
            <%  
                //pr.getTableau().setNameActe("miseencarton");
                 out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
            </div>
        </form>
        <% } else {
            %><center><h4>Aucun details </h4></center><%
        }
        %>
</div>
    
