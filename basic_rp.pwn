#include <a_samp>
#include <dini>

#define COLOR_WHITE 0xFFFFFFAA
#define PATH "Accounts/%s.ini"

new gPlayerLogged[MAX_PLAYERS];
new gPlayerName[MAX_PLAYERS][24];

public OnGameModeInit()
{
    SetGameModeText("Basic RP");
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 0, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, gPlayerName[playerid], 24);
    gPlayerLogged[playerid] = 0;
    SendClientMessage(playerid, COLOR_WHITE, "Welcome to Basic RP Server!");
    SendClientMessage(playerid, COLOR_WHITE, "Use /register [password] or /login [password]");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    gPlayerLogged[playerid] = 0;
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256], tmp[256];
    sscanf(cmdtext, "%s %s", cmd, tmp);

    if (strcmp(cmd, "/register", true) == 0)
    {
        if (gPlayerLogged[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "You are already logged in.");
        if (strlen(tmp) == 0) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /register [password]");

        new file[64];
        format(file, sizeof(file), PATH, gPlayerName[playerid]);
        if (dini_Exists(file)) return SendClientMessage(playerid, COLOR_WHITE, "Account already exists. Use /login");

        dini_Create(file);
        dini_Set(file, "Password", tmp);
        dini_IntSet(file, "Money", 5000);
        gPlayerLogged[playerid] = 1;
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, 5000);
        SendClientMessage(playerid, COLOR_WHITE, "You are now registered and logged in!");
        return 1;
    }

    if (strcmp(cmd, "/login", true) == 0)
    {
        if (gPlayerLogged[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "You are already logged in.");
        if (strlen(tmp) == 0) return SendClientMessage(playerid, COLOR_WHITE, "Usage: /login [password]");

        new file[64];
        format(file, sizeof(file), PATH, gPlayerName[playerid]);
        if (!dini_Exists(file)) return SendClientMessage(playerid, COLOR_WHITE, "Account not found. Use /register");

        new pass[32];
        dini_Get(file, "Password", pass);
        if (!strcmp(tmp, pass, false)) {
            gPlayerLogged[playerid] = 1;
            ResetPlayerMoney(playerid);
            GivePlayerMoney(playerid, dini_Int(file, "Money"));
            SendClientMessage(playerid, COLOR_WHITE, "Login successful!");
        } else {
            SendClientMessage(playerid, COLOR_WHITE, "Wrong password.");
        }
        return 1;
    }

    if (strcmp(cmd, "/stats", true) == 0)
    {
        if (!gPlayerLogged[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "You must login first.");

        new file[64];
        format(file, sizeof(file), PATH, gPlayerName[playerid]);
        new msg[128];
        format(msg, sizeof(msg), "Money: $%d", dini_Int(file, "Money"));
        SendClientMessage(playerid, COLOR_WHITE, msg);
        return 1;
    }

    return 0;
}
