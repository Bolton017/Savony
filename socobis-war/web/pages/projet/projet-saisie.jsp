<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="affichage.PageInsert"%>
<%@ page import="user.UserEJB" %>
<%@ page import="fabrication.Fabrication" %>
<%@ page import="affichage.Liste" %>

<% try{ 
    UserEJB u = (user.UserEJB) session.getValue("u");
    String mapping = "fabrication.Fabrication";
    String nomTable = "FABRICATION";
    String apres = "projet/projet-fiche.jsp";

    Fabrication o = new Fabrication();
    o.setNomTable("FABRICATION");
    PageInsert pi = new PageInsert(o, request, u);
    pi.setLien((String) session.getValue("lien"));  
    pi.setTitre("Saisie d'un projet");

    Liste[] liste=new Liste[1];
    liste[0]=new Liste("lancePar",new bean.TypeObjet("MAGASINPOINT"),"val","id");
    pi.getFormu().changerEnChamp(liste);

    pi.getFormu().getChamp("lanceur").setLibelle("Lanceur");
    pi.getFormu().getChamp("lanceur").setAutre("readonly");
    pi.getFormu().getChamp("lanceur").setDefaut(String.valueOf(u.getUser().getRefuser()));
    pi.getFormu().getChamp("lancePar").setLibelle("Lanc&eacute;e par");
    pi.getFormu().getChamp("remarque").setLibelle("Titre");
    pi.getFormu().getChamp("libelle").setLibelle("Description");
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("idOf").setVisible(false);
    pi.getFormu().getChamp("idOffille").setVisible(false);
    pi.getFormu().getChamp("estUnProjet").setVisible(false);
    pi.getFormu().getChamp("estUnProjet").setDefaut("1");
    pi.getFormu().getChamp("fabricationPrec").setVisible(false);
    pi.getFormu().getChamp("fabricationSuiv").setVisible(false);
    pi.getFormu().getChamp("equipe").setVisible(false);
    pi.getFormu().getChamp("cible").setVisible(false);
    pi.getFormu().getChamp("idBc").setVisible(false);
    pi.getFormu().getChamp("besoin").setVisible(false);
    pi.getFormu().getChamp("etat").setVisible(false);
 
    String[] ordre = {"lanceur","lancePar","remarque","libelle","daty"};
    pi.getFormu().setOrdre(ordre);
 
    String acte = request.getParameter("acte");
    if(acte != null && acte.equalsIgnoreCase("update")){
        pi.setTitre("Modification d'un projet");
    }

    pi.preparerDataFormu();
    pi.getFormu().makeHtmlInsertTabIndex();
%>

<div class="content-wrapper">
    <h1><%=pi.getTitre()%></h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomTable%>" id="<%=nomTable%>">
        <%
            out.println(pi.getFormu().getHtmlInsert());
            out.println(pi.getHtmlAddOnPopup());
        %>
        <input name="acte" type="hidden" id="nature" value="insert">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomTable%>">
    </form>
</div>

<% } catch (Exception e) {
  e.printStackTrace();
%>
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();
</script>
<% }%>

