<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.Client, mg.vola.dao.ClientDAO" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Gestion des Clients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --bg-page: #F1F5F9;
        }

        body { 
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page); 
            color: var(--main-dark);
        }

        /* --- ELEMENTS DE PAGE --- */
        .header-section { 
            background: white; 
            border-left: 5px solid var(--accent-mint);
            border-radius: 15px;
        }

        .card { border: none; border-radius: 20px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
        
        .table thead { 
            background-color: var(--main-dark); 
            color: white; 
        }
        .table thead th { border: none; padding: 15px; }

        .btn-mint {
            background-color: var(--accent-mint);
            color: var(--main-dark);
            font-weight: 600;
            border: none;
        }
        .btn-mint:hover { background-color: #24bca8; color: var(--main-dark); }

        .btn-dark-nova {
            background-color: var(--main-dark);
            color: white;
            border: none;
        }

        .search-bar { 
            border-radius: 50px !important; 
            padding-left: 20px; 
            border: 2px solid #e2e8f0 !important; 
        }
        .search-bar:focus { border-color: var(--accent-mint) !important; box-shadow: none; }

        .badge-sexe { background: #e2e8f0; color: var(--main-dark); font-weight: 600; }
        .solde-highlight { color: #0d9488; font-weight: 700; }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">
    <div class="header-section shadow-sm p-4 mb-5 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Gestion des Clients</h2>
            <p class="mb-0 text-muted">Répertoire centralisé des utilisateurs NovaCash</p>
        </div>
    </div>

    <div class="row mb-4 align-items-center">
        <div class="col-md-6">
            <input type="text" id="searchInput" class="form-control search-bar" placeholder="Rechercher par nom ou numéro...">
        </div>
        <div class="col-md-6 text-md-end mt-3 mt-md-0">
            <button class="btn btn-dark-nova rounded-pill px-4 py-2 shadow-sm" type="button" data-bs-toggle="collapse" data-bs-target="#formulaireAjout">
                + Ajouter un client
            </button>
        </div>
    </div>

    <div class="collapse mb-5" id="formulaireAjout">
        <div class="card border-0">
            <div class="card-body p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold m-0">Nouvel Enregistrement</h5>
                    <button type="button" class="btn-close" data-bs-toggle="collapse" data-bs-target="#formulaireAjout"></button>
                </div>
                <form action="ClientServlet" method="POST" class="row g-3" onsubmit="return validerAge('age_ajout')">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Numéro Tel</label>
                        <input type="text" name="numtel" class="form-control" placeholder="034..." required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Nom Complet</label>
                        <input type="text" name="nom" class="form-control" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label small fw-bold">Email</label>
                        <input type="email" name="mail" class="form-control" required>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label small fw-bold">Sexe</label>
                        <select name="sexe" class="form-select">
                            <option value="M">M</option><option value="F">F</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label small fw-bold">Âge</label>
                        <input type="number" name="age" id="age_ajout" class="form-control" min="18" value="18" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label small fw-bold">Solde initial (Ar)</label>
                        <input type="number" name="solde" class="form-control" value="0" min="0">
                    </div>
                    <div class="col-12 mt-4 text-end">
                        <button type="submit" class="btn btn-mint px-5 rounded-pill shadow-sm">Confirmer</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="clientTable">
                    <thead>
                        <tr>
                            <th class="ps-4">Numéro</th>
                            <th>Nom</th>
                            <th>Email</th>
                            <th>Sexe</th>
                            <th>Âge</th>
                            <th>Solde</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            ClientDAO dao = new ClientDAO();
                            List<Client> clients = dao.listerClients(""); 
                            for(Client c : clients) {
                        %>
                        <tr class="align-middle client-row">
                            <td class="ps-4 fw-bold"><%= c.getNumtel() %></td>
                            <td><%= c.getNom() %></td>
                            <td><%= c.getMail() %></td>
                            <td><span class="badge rounded-pill badge-sexe"><%= c.getSexe() %></span></td>
                            <td><%= c.getAge() %> ans</td>
                            <td class="solde-highlight"><%= String.format("%, d", c.getSolde()) %> Ar</td>
                            <td class="text-center">
                                <button class="btn btn-outline-dark btn-sm rounded-pill px-3 me-2" 
                                        onclick="ouvrirModale('<%= c.getNumtel() %>', '<%= c.getNom() %>', '<%= c.getMail() %>', '<%= c.getSexe() %>', '<%= c.getAge() %>', '<%= c.getSolde() %>')">
                                    Editer
                                </button>
                                <form action="ClientServlet" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="supprimer">
                                    <input type="hidden" name="numtel" value="<%= c.getNumtel() %>">
                                    <button type="submit" class="btn btn-link text-danger btn-sm text-decoration-none" onclick="return confirm('Supprimer ce client ?')">Supprimer</button>
                                </form>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="modalModif" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <form action="ClientServlet" method="POST" class="modal-content border-0 shadow-lg" onsubmit="return validerAge('m_age')">
            <div class="modal-header bg-dark text-white">
                <h5 class="modal-title fw-bold">Mise à jour client : <span id="displayNum"></span></h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="numtel" id="m_numtel">
                <div class="row g-3">
                    <div class="col-md-6"><label class="form-label small fw-bold">Nom Complet</label><input type="text" name="nom" id="m_nom" class="form-control" required></div>
                    <div class="col-md-6"><label class="form-label small fw-bold">Email</label><input type="email" name="mail" id="m_mail" class="form-control" required></div>
                    <div class="col-md-4"><label class="form-label small fw-bold">Sexe</label><select name="sexe" id="m_sexe" class="form-select"><option value="M">M</option><option value="F">F</option></select></div>
                    <div class="col-md-4"><label class="form-label small fw-bold">Âge</label><input type="number" name="age" id="m_age" class="form-control" min="18" required></div>
                    <div class="col-md-4"><label class="form-label small fw-bold">Solde (Ar)</label><input type="number" name="solde" id="m_solde" class="form-control" min="0"></div>
                </div>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Fermer</button>
                <button type="submit" class="btn btn-dark-nova rounded-pill px-4">Sauvegarder</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.getElementById('searchInput').addEventListener('keyup', function() {
    let filter = this.value.toLowerCase();
    document.querySelectorAll('.client-row').forEach(row => {
        row.style.display = row.innerText.toLowerCase().includes(filter) ? "" : "none";
    });
});

function validerAge(id) {
    if (document.getElementById(id).value < 18) {
        alert("Action impossible : Le client doit être majeur.");
        return false;
    }
    return true;
}

function ouvrirModale(num, nom, mail, sexe, age, sol) {
    document.getElementById('m_numtel').value = num;
    document.getElementById('displayNum').innerText = num;
    document.getElementById('m_nom').value = nom;
    document.getElementById('m_mail').value = mail;
    document.getElementById('m_sexe').value = sexe;
    document.getElementById('m_age').value = age;
    document.getElementById('m_solde').value = sol;
    new bootstrap.Modal(document.getElementById('modalModif')).show();
}
</script>
</body>
</html>