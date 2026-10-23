package servlet.paie.absence;

import com.google.gson.JsonObject;
import paie.conge.MouvementAbsence;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "SoldeCongePermission", urlPatterns = {"/soldeCongePermission"})
public class SoldeCongePermission extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException
    {
        String idPersonnel = req.getParameter("idPersonnel");

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        try {
            MouvementAbsence mvt = new MouvementAbsence();
            mvt.setIdPersonnel(idPersonnel);

            System.out.println("ID ANATY SERVLET: " + idPersonnel);


            double resteConge = mvt.getSoldeCongePers();
            double restePermission = mvt.getSoldePermissionPers();

            System.out.println(resteConge);
            System.out.println(restePermission);

            JsonObject json = new JsonObject();
            json.addProperty("resteConge", resteConge);
            json.addProperty("restePermission", restePermission);

            out.print(json.toString());
        } catch (Exception e) {
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\": \"Erreur lors du calcul des soldes.\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
}
