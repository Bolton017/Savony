<%-- 
    Document   : paiepersonnelelementpaie-modif
    Created on : 21 d�c. 2020, 16:58:42
    Author     : Sanda
--%>

<%@page import="paie.elementpaie.PaiePersonnelElementpaie"%>
<%@page import="affichage.PageUpdate"%> 
<%@page import="user.UserEJB"%> 
<%@page import="affichage.Liste"%> 
<%@page import="bean.TypeObjet"%> 
<%@page import="utilitaire.Utilitaire"%> 
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.elementpaie.PaiePersonnelElementpaie",
            nomtable = "paie_personnel_elementpaie",
            apres = "paie/fonction/paiepersonnelelementpaie-fiche.jsp",
            titre = "Modification paie personnel element";
    
    PaiePersonnelElementpaie  objet = new PaiePersonnelElementpaie();
    objet.setNomTable(nomtable);
    PageUpdate pi = new PageUpdate(objet, request, u);
    pi.setLien((String) session.getValue("lien"));  
    
    affichage.Champ[] liste = new affichage.Champ[1];
    Liste mois = new Liste("moisregularisation");
    mois.makeListeMois();
    liste[0] = mois;
    pi.getFormu().changerEnChamp(liste);
	
    pi.getFormu().getChamp("idpersonnel").setPageAppelComplete("paie.log.LogPersonnelValide","id","log_personnel_v2");
    //pi.getFormu().getChamp("idpersonnel").setPageAppel("choix/logPersonnelChoix.jsp");
    pi.getFormu().getChamp("idpersonnel").setAutre("readonly");
    pi.getFormu().getChamp("code_rubrique").setPageAppelComplete("paie.employe.PaieRubrique","id","paie_rubrique");
    pi.getFormu().getChamp("idcategorie_qualification").setPageAppelComplete("paie.CategorieQualification","id","log_personcategorie_qualificationlibnel_v2");
    //pi.getFormu().getChamp("idcategorie_qualification").setPageAppel("choix/CategorieQualificationChoix.jsp");
    pi.getFormu().getChamp("idcategorie_qualification").setAutre("readonly");
    pi.getFormu().getChamp("idfonction").setPageAppelComplete("paie.edition.PaieFonction","id","PAIE_FONCTIONLIBELLE");
   // pi.getFormu().getChamp("idfonction").setPageAppel("choix/paieFonctionChoix.jsp");
    pi.getFormu().getChamp("idfonction").setAutre("readonly");

    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("anneeregularisation").setDefaut(Utilitaire.getAnneeEnCours());
    pi.getFormu().getChamp("date_fin").setLibelle("Date fin");
    pi.getFormu().getChamp("date_debut").setLibelle("Date debut");
    pi.getFormu().getChamp("code_rubrique").setLibelle("Rubrique");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("id_objet").setLibelle("Objet");
    pi.getFormu().getChamp("idfonction").setLibelle("Fonction");
    pi.getFormu().getChamp("idcategorie_qualification").setLibelle("Categorie qualification");
    pi.getFormu().getChamp("moisregularisation").setLibelle("Mois de regularisation");
    pi.getFormu().getChamp("anneeregularisation").setLibelle("annee de regularisation");
    pi.getFormu().getChamp("gain").setLibelle("Montant");
    pi.getFormu().getChamp("id").setVisible(false);
            
    pi.preparerDataFormu();
%>
<div class="content-wrapper">
    <h1> <%=titre%></h1>
    
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="<%=nomtable%>" id="<%=nomtable%>">
        <%
            pi.getFormu().makeHtmlInsertTabIndex();
            out.println(pi.getFormu().getHtmlInsert());
        %>
        <input name="acte" type="hidden" id="nature" value="update">
        <input name="bute" type="hidden" id="bute" value="<%=apres%>">
        <input name="classe" type="hidden" id="classe" value="<%=mapping%>">
        <input name="nomtable" type="hidden" id="nomtable" value="<%=nomtable%>">
    </form>
</div>
<%
} catch (Exception e) {
    e.printStackTrace();
%>
<script language="JavaScript"> 
	alert('<%=e.getMessage()%>');
    history.back();</script>
<% }%>


