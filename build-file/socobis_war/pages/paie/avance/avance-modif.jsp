<%-- 
    Document   : avance-modif
    Created on : 10 d�c. 2020, 15:44:38
    Author     : mihary
--%>
<%@page import="paie.log.LogPersonnel"%>
<%@page import="paie.avance.Avance"%>
<%@page import="affichage.PageUpdate"%> 
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.Liste"%> 
<%@page import="bean.TypeObjet"%> 
<%
    try{
    String autreparsley = "data-parsley-range='[8, 40]' required";
    UserEJB u = (user.UserEJB) session.getValue("u");
    String  mapping = "paie.avance.Avance",
            nomtable = "Avance",
            apres = "paie/avance/avance-fiche.jsp",
            titre = "Modification de l'avance";
    
    
    Avance  objet = new Avance();
    
    objet.setNomTable(nomtable);
    PageUpdate pi = new PageUpdate(objet, request, u);
    pi.setLien((String) session.getValue("lien"));  
    
    String idpersonnel= pi.getFormu().getChamp("idpersonnel").getValeur();
    System.out.println("idpersonnel=====>"+idpersonnel);
    
    affichage.Champ[] liste = new affichage.Champ[1];
    TypeObjet liste1 = new TypeObjet();
    liste1.setNomTable("typeavance");
    liste[0] = new Liste("idtypeavance", liste1, "val", "id");
    pi.getFormu().changerEnChamp(liste);
	
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.getFormu().getChamp("id").setVisible(false);
    pi.getFormu().getChamp("daty").setVisible(false);

    
    String idpers = pi.getFormu().getChamp("idpersonnel").getValeur();
    LogPersonnel ls = new LogPersonnel();
    ls.setId(idpers);  
    String lib_pers = ls.getMotClesString(ls);
    System.out.println("lib_pers===>"+lib_pers);
    pi.getFormu().getChamp("remarque").setLibelle("Remarque");
     pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idpersonnel").setAutre("placeholder='"+lib_pers+"'readonly");
    pi.getFormu().getChamp("idtypeavance").setLibelle("Type");
    pi.getFormu().getChamp("montant").setLibelle("Montant");
    pi.getFormu().getChamp("nbremboursement").setLibelle("Nombre de remboursement");
    pi.getFormu().getChamp("dateavance").setLibelle("Date de l'avance");
            
    String[] colOrdre = {"dateavance","remarque","idtypeavance","montant","nbremboursement"};
    pi.getFormu().setOrdre(colOrdre);
    
    pi.preparerDataFormu();
%>
<script>
    
     function manova() { 
        var value_idtypeavance = $('#idtypeavance').val();
        switch(value_idtypeavance){
            /* Sur salaire */ 
            case "PRU0447" : 
                localStorage.nbremboursement=document.getElementById('nbremboursement').value;
                document.getElementById('nbremboursement').value='1';
                $('#nbremboursement').attr('readonly', 'readonly');
                break;
            /* Exceptionnel */
            case "PRU0453" : 
                //document.getElementById('nbremboursement').value=localStorage.nbremboursement;
                $('#nbremboursement').removeAttr('readonly');
                break; 
        }
    }

    function loads() {
        $('#idtypeavance').attr('onChange', 'manova()');
        manova();
        }
    window.onload =loads; 
</script>
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
<script language="JavaScript"> alert('<%=e.getMessage()%>');
    history.back();</script>

<% }%>
