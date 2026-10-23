<%-- 
    Document   : retraitFraisMedicaux-modif
    Created on : 17 aout 2021, 17:01:02
    Author     : Michel
--%>
<%@page import="user.UserEJB"%>
<%@page import="utilitaire.ConstanteEtat"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="affichage.PageUpdate"%>
<%@page import="mg.fer.paie.RetraitFraisMedicaux"%>
<%
    try{
    UserEJB u = (user.UserEJB) session.getValue("u");
    RetraitFraisMedicaux retraitFraisMedicaux = new RetraitFraisMedicaux();
    retraitFraisMedicaux.setNomTable("retrait_frais_medicaux_libcomplet");
    PageUpdate pi = new PageUpdate(retraitFraisMedicaux, request, (user.UserEJB) session.getValue("u"));
    pi.setLien((String) session.getValue("lien"));
    retraitFraisMedicaux =(RetraitFraisMedicaux)pi.getBase();
    pi.getFormu().getChamp("daty").setLibelle("Date");
    pi.getFormu().getChamp("id").setLibelle("ID");
    pi.getFormu().getChamp("idpersonnel").setPageAppel("choix/personnelChoix.jsp", "idpersonnel;idpersonnellibelle");
    pi.getFormu().getChamp("idpersonnel").setAutre("readonly");
    pi.getFormu().getChamp("idpersonnel").setLibelle("Personnel");
    pi.getFormu().getChamp("idpersonnel_lib").setVisible(false);
    pi.getFormu().getChamp("description").setLibelle("Description");
    pi.getFormu().getChamp("montant").setLibelle("Montant");   
//    pi.getFormu().getChamp("montant").setAutre("readonly");
    pi.getFormu().getChamp("etat").setVisible(false);
    pi.preparerDataFormu();
    
    retraitFraisMedicaux = (RetraitFraisMedicaux)pi.getBase();
    if(u.getUser().getRang()<6){
         pi.getFormu().getChamp("montant").setAutre("readonly");
    }
    
%>
<div class="content-wrapper">
    <h1>Modification du retrait de frais m&eacute;dicaux</h1>
    <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post" name="starticle" id="starticle">
    <%
        pi.getFormu().makeHtmlInsertTabIndex();
        out.println(pi.getFormu().getHtmlInsert());
    %>
    <input name="acte" type="hidden" id="nature" value="update">
    <input name="bute" type="hidden" id="bute" value="paie/frais/retrait-frais-medicaux-fiche.jsp">
    <input name="nomtable" type="hidden" id="nomtable" value="retrait_frais_medicaux">
    <input name="classe" type="hidden" id="classe" value="mg.fer.paie.RetraitFraisMedicaux">
    </form>
</div>
    <script>
        document.getElementById("idpersonnellibelle").value = "<%= Utilitaire.champNull(retraitFraisMedicaux.getIdpersonnel_lib()) %>";
        function verifierMontant() {
        const montant = parseFloat(document.getElementById('montant').value) || 0;
        const reste = parseFloat(document.getElementById('reste').value) || 0;
        const inputMontant = document.getElementById('montant');

        if (montant > reste) {
            inputMontant.classList.add('error'); 
        } else {
            inputMontant.classList.remove('error'); 
        }
    }

    document.getElementById('montant').addEventListener('input', verifierMontant);
    </script>
    <%
    }catch(Exception e){
e.printStackTrace();
}
    %>