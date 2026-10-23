
<%@page import="vente.BoncommandeDetailsCarton"%>
<%@ page import="user.*" %>
<%@ page import="bean.*" %>
<%@ page import="utilitaire.*" %>
<%@ page import="affichage.*" %>
<%@ page import="fabrication.*" %>

<%
    BoncommandeDetailsCarton  bc = new BoncommandeDetailsCarton();
    bc.setNomTable("VUE_SUIVI_CARTON_LIVRAISON");
    String listeCrt[] = {};
    String listeInt[] = {};
    String libEntete[] =  {"id","produitLib","quantiteBcf", "quantiteCartonFille","resteCartonFille"};
    PageRecherche pr = new PageRecherche(bc, request, listeCrt, listeInt, 3, libEntete, libEntete.length);
    pr.setAWhere(" and idbc_mere ='"+request.getParameter("id")+"' ");
    pr.getApres();
    pr.setUtilisateur((user.UserEJB) session.getValue("u"));
    pr.setLien((String) session.getValue("lien"));
    String[] colSomme = null;
    pr.creerObjetPage(libEntete, colSomme);
    int nombreLigne = pr.getTableau().getData().length;
    String libEnteteAffiche[] =  {"Bon de commande fille","Produit","Quantit&eacute;", "Quantit&eacute; mise en carton","Quantit&eacute; reste &agrave; mettre en carton"};
    pr.getTableau().setLibelleAffiche(libEnteteAffiche);
    pr.getTableau().setNameBoutton("Mise en carton");
if(pr.getTableau().getHtmlWithCheckbox() != null){%>
<div class="box-body">
       <form action="<%=pr.getLien()%>?but=vente/apresMiseenCarton.jsp" id='modif-form' method="post" data-parsley-validate>
            <input name="acte" type="hidden" id="acte" value="miseencarton">
            <input name="idbc" type="hidden" id="idbc" value="<%=request.getParameter("id")%>">
            <input name="nombreLigne" type="hidden" id="nombreLigne" value="<%=nombreLigne%>">
            <div class="result mt-5 table-result">
            <%  
                pr.getTableau().setNameActe("miseencarton");
                out.println(pr.getTableau().getHtmlWithCheckbox());
            %>
            </div>
        </form>
<% } else {
            %><center><h4>Aucun details </h4></center><%
        }
        %>

</div>
    
