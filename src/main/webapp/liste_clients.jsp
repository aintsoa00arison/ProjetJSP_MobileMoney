<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, mg.vola.models.Client, mg.vola.dao.ClientDAO" %>

<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>NovaCash | Gestion des Clients</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        :root {
            --main-dark: #0F172A;
            --accent-mint: #2DD4BF;
            --accent-rose: #F43F5E;
            --bg-page: #F1F5F9;
            --soft-radius: 12px;
            --border-color: #E2E8F0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--bg-page);
            color: var(--main-dark);
        }

        /* --- HEADER --- */
        .header-card {
            background: white;
            border-left: 6px solid var(--accent-mint);
            border-radius: var(--soft-radius);
        }

        /* --- SEARCH BAR --- */
        .search-wrap {
            position: relative;
        }
        .search-wrap .bi {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94A3B8;
            font-size: 1rem;
            pointer-events: none;
        }
        .search-wrap input {
            padding-left: 44px;
            border-radius: var(--soft-radius) !important;
            border: 1px solid var(--border-color) !important;
            background: white;
            transition: all 0.2s;
            height: 46px;
        }
        .search-wrap input:focus {
            border-color: var(--accent-mint) !important;
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1) !important;
        }

        /* --- FORMULAIRE AJOUT --- */
        .form-card {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
            overflow: hidden;
        }

        .form-card-header {
            background: var(--main-dark);
            padding: 16px 24px;
            color: white;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .form-label { font-size: 0.82rem; font-weight: 600; color: #64748B; margin-bottom: 6px; }

        .form-control, .form-select {
            border-radius: var(--soft-radius);
            padding: 10px 16px;
            border: 1px solid var(--border-color);
            background-color: #F8FAFC;
            transition: all 0.2s;
            font-size: 0.9rem;
        }
        .form-control:focus, .form-select:focus {
            background-color: #fff;
            border-color: var(--accent-mint);
            box-shadow: 0 0 0 4px rgba(45, 212, 191, 0.1);
        }

        /* --- TABLEAU --- */
        .dashboard-container {
            background: white;
            border-radius: var(--soft-radius);
            border: 1px solid var(--border-color);
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(15, 23, 42, 0.05);
        }

        .table-vola thead th {
            background-color: transparent;
            color: #64748B;
            font-size: 0.82rem;
            font-weight: 600;
            padding: 14px 16px;
            border-bottom: 2px solid var(--border-color);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .table-vola tbody td {
            padding: 14px 16px;
            border-bottom: 1px solid #F1F5F9;
            vertical-align: middle;
            font-size: 0.88rem;
            color: #334155;
        }

        .client-row {
            transition: all 0.2s;
            border-left: 3px solid transparent;
        }
        .client-row:hover {
            background-color: #F8FAFC;
            border-left: 3px solid var(--accent-mint);
        }

        /* --- BADGES & STATUTS --- */
        .badge-sexe-m {
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            background: #DBEAFE;
            color: #1E40AF;
        }
        .badge-sexe-f {
            padding: 5px 12px;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            background: #FCE7F3;
            color: #9D174D;
        }

        .solde-highlight { color: #0D9488; font-weight: 700; }
        .num-pill {
            font-size: 0.82rem;
            font-weight: 700;
            background: #F1F5F9;
            color: var(--main-dark);
            padding: 4px 10px;
            border-radius: 6px;
            letter-spacing: 0.02em;
        }

        /* --- AVATAR --- */
        .avatar-circle {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, #DCFCE7, #A7F3D0);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.75rem;
            color: #065F46;
            flex-shrink: 0;
        }

        /* --- BOUTONS --- */
        .btn-action {
            border-radius: var(--soft-radius);
            padding: 12px 24px;
            font-weight: 600;
            transition: 0.3s;
            border: none;
        }
        .btn-mint { background: var(--accent-mint); color: var(--main-dark); }
        .btn-mint:hover { background: #24b8a5; transform: translateY(-2px); color: var(--main-dark); }

        .btn-edit {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background: white;
            color: var(--main-dark);
            transition: all 0.2s;
        }
        .btn-edit:hover {
            background: var(--main-dark);
            color: white;
            border-color: var(--main-dark);
        }

        .btn-delete {
            font-size: 0.8rem;
            font-weight: 600;
            padding: 6px 14px;
            border-radius: 8px;
            border: 1px solid #FEE2E2;
            background: #FEF2F2;
            color: #DC2626;
            transition: all 0.2s;
            text-decoration: none;
        }
        .btn-delete:hover {
            background: #DC2626;
            color: white;
            border-color: #DC2626;
        }

        /* --- COMPTEUR --- */
        .count-badge {
            background: #F1F5F9;
            color: #475569;
            font-size: 0.78rem;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 20px;
        }

        /* --- EMPTY STATE --- */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #94A3B8;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="container py-5">

    <!-- === HEADER === -->
    <div class="header-card shadow-sm p-4 mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="mb-0 fw-bold">Gestion des Clients</h2>
            <p class="mb-0 text-muted">Répertoire centralisé des utilisateurs NovaCash</p>
        </div>
        <button class="btn btn-dark px-4 py-2 fw-bold" style="border-radius: 10px;"
                data-bs-toggle="collapse" data-bs-target="#formulaireAjout"
                id="btnToggleForm">
            <i class="bi bi-person-plus-fill me-2"></i>Nouveau client
        </button>
    </div>

    <!-- === FORMULAIRE AJOUT (COLLAPSIBLE) === -->
    <div class="collapse mb-4" id="formulaireAjout">
        <div class="form-card">
            <div class="form-card-header">
                <div>
                    <span class="fw-bold fs-6">Nouvel enregistrement</span>
                    <span class="ms-2 small opacity-75">Tous les champs marqués * sont obligatoires</span>
                </div>
                <button type="button" class="btn-close btn-close-white btn-sm"
                        data-bs-toggle="collapse" data-bs-target="#formulaireAjout"></button>
            </div>
            <div class="p-4">
                <form action="ClientServlet" method="POST" class="row g-3" onsubmit="return validerAge('age_ajout')">
                    <input type="hidden" name="action" value="ajouter">
                    <div class="col-md-2">
                        <label class="form-label">Numéro Tel *</label>
                        <input type="text" name="numtel" class="form-control" placeholder="034..." required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Nom Complet *</label>
                        <input type="text" name="nom" class="form-control" placeholder="Jean Dupont" required>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Email *</label>
                        <input type="email" name="mail" class="form-control" placeholder="email@exemple.com" required>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label">Sexe</label>
                        <select name="sexe" class="form-select">
                            <option value="M">M</option>
                            <option value="F">F</option>
                        </select>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label">Âge *</label>
                        <input type="number" name="age" id="age_ajout" class="form-control" min="18" value="18" required>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">Solde initial (Ar)</label>
                        <input type="number" name="solde" class="form-control" value="0" min="0" placeholder="0">
                    </div>
                    <div class="col-12 mt-3 d-flex justify-content-end gap-2">
                        <button type="button" class="btn btn-light px-4 fw-semibold" style="border-radius: 10px;"
                                data-bs-toggle="collapse" data-bs-target="#formulaireAjout">
                            Annuler
                        </button>
                        <button type="submit" class="btn btn-mint btn-action px-5 shadow-sm">
                            <i class="bi bi-check2-circle me-2"></i>Confirmer l'ajout
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- === BARRE RECHERCHE + COMPTEUR === -->
    <div class="row mb-3 align-items-center g-3">
        <div class="col-md-6">
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="searchInput" class="form-control" placeholder="Rechercher par nom ou numéro...">
            </div>
        </div>
        <div class="col-md-6 d-flex justify-content-md-end align-items-center gap-2">
            <span class="count-badge">
                <i class="bi bi-people-fill me-1"></i>
                <span id="countClients">
                    <%
                        ClientDAO dao = new ClientDAO();
                        List<Client> clients = dao.listerClients("");
                    %>
                    <%= clients.size() %>
                </span> clients
            </span>
        </div>
    </div>

    <!-- === TABLEAU === -->
    <div class="dashboard-container">
        <div class="table-responsive">
            <table class="table table-vola mb-0" id="clientTable">
                <thead>
                    <tr>
                        <th style="padding-left: 20px;">Client</th>
                        <th>Numéro</th>
                        <th>Email</th>
                        <th class="text-center">Sexe</th>
                        <th class="text-center">Âge</th>
                        <th class="text-end">Solde</th>
                        <th class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Client c : clients) {
                            String initiales = c.getNom().length() >= 2
                                ? c.getNom().substring(0, 2).toUpperCase()
                                : c.getNom().toUpperCase();
                    %>
                    <tr class="align-middle client-row">
                        <td><%= c.getNumtel() %></span></td>
                        <td style="padding-left: 20px;">
                            <div class="d-flex align-items-center gap-2">
                                <!-- <div class="avatar-circle"><%= initiales %></div> -->
                                <%= c.getNom() %>
                            </div>
                        </td>

                        <td class="text-muted" style="font-size:0.85rem;"><%= c.getMail() %></td>
                        <td class="text-center">
                            <% if ("F".equals(c.getSexe())) { %>
                                <span class="badge-sexe-f"><%= c.getSexe() %></span>
                            <% } else { %>
                                <span class="badge-sexe-m"><%= c.getSexe() %></span>
                            <% } %>
                        </td>
                        <td class="text-center text-muted"><%= c.getAge() %></td>
                        <td class="text-end solde-highlight"><%= String.format("%,d", c.getSolde()) %></td>
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-2">
                                <button class="btn-edit"
                                        onclick="ouvrirModale('<%= c.getNumtel() %>', '<%= c.getNom() %>', '<%= c.getMail() %>', '<%= c.getSexe() %>', '<%= c.getAge() %>', '<%= c.getSolde() %>')">
                                    <i class="bi bi-pencil me-1"></i>
                                </button>
                                <form action="ClientServlet" method="POST" class="d-inline m-0">
                                    <input type="hidden" name="action" value="supprimer">
                                    <input type="hidden" name="numtel" value="<%= c.getNumtel() %>">
                                    <button type="submit" class="btn-delete"
                                            onclick="return confirm('Supprimer le client <%= c.getNom() %> ?')">
                                        <i class="bi bi-trash me-1"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                    <tr id="emptyRow" style="display:none;">
                        <td colspan="7">
                            <div class="empty-state">
                                <i class="bi bi-search" style="font-size: 2rem;"></i>
                                <p class="mt-2 mb-0 fw-semibold">Aucun client trouvé</p>
                                <p class="small">Essayez un autre nom ou numéro.</p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- ===== MODAL MODIFICATION ===== -->
<div class="modal fade" id="modalModif" tabindex="-1">
    <div class="modal-dialog modal-lg modal-dialog-centered">
        <form action="ClientServlet" method="POST" class="modal-content border-0 shadow-lg"
              style="border-radius: 16px; overflow: hidden;"
              onsubmit="return validerAge('m_age')">
            <div class="modal-header border-0 p-4" style="background: var(--main-dark);">
                <div>
                    <h5 class="modal-title fw-bold text-white mb-0">
                        <i class="bi bi-person-gear me-2"></i>Mise à jour client
                    </h5>
                    <span class="small opacity-75 text-white" id="displayNum"></span>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-4">
                <input type="hidden" name="action" value="modifier">
                <input type="hidden" name="numtel" id="m_numtel">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Nom Complet</label>
                        <input type="text" name="nom" id="m_nom" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Email</label>
                        <input type="email" name="mail" id="m_mail" class="form-control" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Sexe</label>
                        <select name="sexe" id="m_sexe" class="form-select">
                            <option value="M">M</option>
                            <option value="F">F</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Âge</label>
                        <input type="number" name="age" id="m_age" class="form-control" min="18" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Solde (Ar)</label>
                        <input type="number" name="solde" id="m_solde" class="form-control" min="0">
                    </div>
                </div>
            </div>
            <div class="modal-footer border-0 p-4 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Annuler</button>
                <button type="submit" class="btn btn-mint btn-action px-4 shadow-sm">
                    <i class="bi bi-check2-circle me-2"></i>Sauvegarder
                </button>
            </div>
        </form>
    </div>
</div>

<!-- ===== TOAST ===== -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" style="z-index: 1100;">
    <div id="liveToast" class="toast align-items-center text-white border-0 shadow-lg" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body fw-bold" id="toastMsg"></div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function showNotify(message, type) {
        const toastEl = document.getElementById('liveToast');
        document.getElementById('toastMsg').innerText = message;
        toastEl.className = 'toast align-items-center text-white border-0 shadow-lg bg-' + (type === 'success' ? 'success' : 'danger');
        bootstrap.Toast.getOrCreateInstance(toastEl).show();
    }

    document.getElementById('searchInput').addEventListener('keyup', function () {
        const filter = this.value.toLowerCase();
        const rows = document.querySelectorAll('.client-row');
        let visible = 0;
        rows.forEach(row => {
            const match = row.innerText.toLowerCase().includes(filter);
            row.style.display = match ? '' : 'none';
            if (match) visible++;
        });
        document.getElementById('countClients').innerText = visible;
        document.getElementById('emptyRow').style.display = visible === 0 ? '' : 'none';
    });

    function validerAge(id) {
        if (parseInt(document.getElementById(id).value) < 18) {
            showNotify('Action impossible : le client doit être majeur (18 ans minimum).', 'error');
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

    window.onload = () => {
        const params = new URLSearchParams(window.location.search);
        if (params.get('msg') === 'added')    showNotify('Client ajouté avec succès !', 'success');
        if (params.get('msg') === 'updated')  showNotify('Client mis à jour avec succès !', 'success');
        if (params.get('msg') === 'deleted')  showNotify('Client supprimé.', 'success');
        if (params.get('msg') === 'error')    showNotify('Une erreur technique est survenue.', 'error');
        window.history.replaceState({}, '', window.location.pathname);
    };
</script>
</body>
</html>
