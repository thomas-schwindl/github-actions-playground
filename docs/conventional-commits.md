# PR-Titel-Check (Conventional Commits)

## Was macht der Check?

Der Job `lint-pr-title` im Workflow `Terraform GitOps` prüft bei jedem Pull Request automatisch, ob der **PR-Titel** dem [Conventional-Commits](https://www.conventionalcommits.org/)-Format entspricht. Läuft der Check fehl, wird das im PR als roter Status-Check angezeigt – bei aktivierter Branch-Protection kann der PR dann nicht gemerged werden.

**Warum der PR-Titel?**
Der PR-Titel wird von unserem `version`-Job als Basis für den automatischen SemVer-Bump ausgewertet (siehe `mathieudutour/github-tag-action`). Nur wenn der Titel korrekt formatiert ist, kann daraus zuverlässig abgeleitet werden, ob es sich um ein Feature, einen Bugfix oder eine reine Wartungsänderung handelt.

**Verwendete Action:** [`amannn/action-semantic-pull-request@v5`](https://github.com/amannn/action-semantic-pull-request)

**Trigger:** `pull_request` – bei `opened`, `edited`, `synchronize`, `reopened`. Der Check läuft also erneut, sobald der PR-Titel nachträglich geändert wird.

---

## Format

```
<type>(<scope>): <beschreibung>
```

- **`<type>`** – Pflichtfeld, siehe [Erlaubte Types](#erlaubte-types) unten
- **`(<scope>)`** – optional, z. B. betroffenes Modul oder Repo-Bereich
- **`:`** – Doppelpunkt, direkt nach `type` bzw. `(scope)`, **kein Slash `/`**
- **` `** – genau ein Leerzeichen nach dem Doppelpunkt (Pflicht!)
- **`<beschreibung>`** – kurze, verständliche Zusammenfassung der Änderung

### Gültige Beispiele

```
feat: neuen VPC-Endpoint hinzufügen
fix: falsche IAM-Policy korrigiert
feat(iam): Cross-Account-Rolle für Logging ergänzen
ci: Versionierung nach Apply statt vor Apply verschieben
chore: Provider-Version auf 5.4.0 angehoben
docs: README für core-infra Modul aktualisiert
```

### Ungültige Beispiele (typische Fehler)

| Falscher Titel | Fehler | Korrektur |
|---|---|---|
| `feat/vpc-endpoint hinzufügen` | Slash statt Doppelpunkt | `feat: vpc-endpoint hinzufügen` |
| `feat(cicd):automatic versioning` | Kein Leerzeichen nach `:` | `feat(cicd): automatic versioning` |
| `Update VPC config` | Kein Type-Präfix vorhanden | `fix: update VPC config` |
| `Feat: neues Modul` | Type muss klein geschrieben sein | `feat: neues Modul` |

---

## Erlaubte Types

| Type | Bedeutung | Löst Versions-Bump aus? |
|---|---|---|
| `feat` | Neues Feature / neue Funktionalität | ✅ Minor (`v1.4.0` → `v1.5.0`) |
| `fix` | Bugfix | ✅ Patch (`v1.4.0` → `v1.4.1`) |
| `docs` | Nur Dokumentation (README, Kommentare) | ❌ |
| `style` | Formatierung, keine Logikänderung (z. B. `terraform fmt`) | ❌ |
| `refactor` | Umstrukturierung ohne Verhaltensänderung | ❌ |
| `perf` | Performance-Verbesserung | ❌ |
| `test` | Tests hinzufügen/anpassen | ❌ |
| `build` | Änderungen am Build-System / Abhängigkeiten | ❌ |
| `ci` | Änderungen an CI/CD-Workflows (`.github/workflows/*`) | ❌ |
| `chore` | Sonstige Wartungsarbeiten (Provider-Version, `.gitignore`, ...) | ❌ |
| `revert` | Rückgängigmachen eines vorherigen Commits/PRs | ❌ |

**Breaking Changes:** Für einen Major-Bump (`v1.4.0` → `v2.0.0`) entweder ein `!` direkt nach dem Type/Scope setzen (`feat!: ...` bzw. `feat(iam)!: ...`) oder `BREAKING CHANGE: ...` in der PR-Beschreibung ergänzen.

---

## Branchnamen (Empfehlung, wird nicht automatisch geprüft)

Der Check validiert **nur den PR-Titel**, nicht den Branchnamen. Trotzdem empfehlen wir aus Konsistenzgründen dasselbe Schema für Branches:

```
<type>/<kurze-beschreibung-in-kebab-case>
```

Beispiele: `feat/vpc-endpoint`, `fix/iam-policy-typo`, `chore/bump-provider-versions`

---

## Wie richte ich das ein / prüfe ich das? (für neue Repos)

1. Workflow-Datei mit dem `lint-pr-title`-Job im Repo hinterlegen (`.github/workflows/terraform.yml`).
2. Unter **Settings → Branches → Branch protection rule für `main`** den Haken bei *"Require status checks to pass before merging"* setzen und den Check **`Check: PR Title (Conventional Commits)`** auswählen.
   - Ohne diesen Schritt läuft der Check nur informativ mit und blockiert keinen Merge!
3. Fertig – ab jetzt wird jeder neue oder bearbeitete PR-Titel automatisch geprüft.

## Was mache ich, wenn der Check fehlschlägt?

1. PR öffnen → oben auf den Stift neben dem Titel klicken (oder in den PR-Settings) → Titel korrigieren.
2. Format gemäß Tabelle oben verwenden (Doppelpunkt + Leerzeichen nicht vergessen).
3. Der Check läuft automatisch erneut (Trigger-Type `edited`), keine manuelle Re-Run-Aktion nötig.

## Zusammenhang mit der Versionierung

Der PR-Titel bestimmt **nicht direkt** die Versionsnummer – dafür wertet `github-tag-action` die **Commit-Messages seit dem letzten Tag** aus. Bei Merge-Strategie "Merge Commit / Rebase" (wie in unseren Repos) bleiben die Einzel-Commits erhalten; der PR-Titel-Check ist daher ein **Mindest-Gate auf PR-Ebene**, ersetzt aber keine Prüfung der einzelnen Commit-Messages. Wer also im PR selbst uneinheitliche Commit-Messages hat, sollte vor dem Merge idealerweise noch squashen oder die Commits sauber formulieren.