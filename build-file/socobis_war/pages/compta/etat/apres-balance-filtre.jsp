<%
try{
    String exercice = (request.getParameter("exercice"));
    String etat = (request.getParameter("etat")) ;
    String typeCompte = request.getParameter("typeCompte");
    String typeEtat = request.getParameter("typeEtat");
    String moisDebut = (request.getParameter("moisDebut"));
    String moisFin = (request.getParameter("moisFin"));
    String duCompte = request.getParameter("duCompte");
    String auCompte = request.getParameter("auCompte");
    String link = "";
    String lien = (String) session.getValue("lien");
    String alert = "";
    if(moisDebut != null || moisDebut.isEmpty() == false || moisFin != null || moisFin.isEmpty() == false){
        if(typeEtat.compareToIgnoreCase("1") == 0){

            link = "compta/etat/balance-compta-general.jsp?moisDebut=" + moisDebut + "&moisFin=" + moisFin + "&debutCompte=" + duCompte + "&finCompte=" + auCompte + "&exercice=" + exercice + "&typeCompte=" + typeCompte + "&etat=" + etat;
        }if(typeEtat.compareToIgnoreCase("2") == 0){
            if(duCompte != null || duCompte.isEmpty() == false || auCompte != null || auCompte.isEmpty() == false ){
                link = "compta/etat/grand-livre-compte.jsp?moisDebut=" + moisDebut + "&moisFin=" + moisFin + "&compteDebut=" + duCompte + "&compteFin=" + auCompte + "&exercice=" + exercice + "&typeCompte=" + typeCompte + "&etat=" + etat ;
            }else{
                alert = "Champ Compte manquant.";
            }
        }
    }else{
        alert = "Champ date manquant.";
    }
    System.out.println(link);
%>
    <script language="JavaScript"> 
        document.location.replace("<%=lien%>?but=<%=link%>");
    </script>
<%
}catch(Exception e){
    e.printStackTrace();
%>
    <script language="JavaScript">
        alert('<%=e.getMessage() %>');
        history.back();
    </script>
<%
}
%>