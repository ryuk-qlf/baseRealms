//////////////////////////////////////////
//           Discord Whitelist          //
//////////////////////////////////////////

/// Config Area ///

var guild = "952650107449409586";
var botToken = "OTkwMzQyMDM1MjUwNzQxMjk5.GKBiIV.OkB0qGNeYLIJJJQ8sVqOWAUgWzMDklO2TFWBJk";

var whitelistRoles = [ // Roles by ID that are whitelisted.
   "952650107449409586" // Moderateur 
   //"930602171706249216" // Public
]

var blacklistRoles = [ // Roles by Id that are blacklisted.
    ""
]

var notWhitelistedMessage = "Maintenance en cours"
//var notWhitelistedMessage = "Vous n'avez pas le role Public"
var noGuildMessage = "Vous n'êtes pas sur le discord"
var blacklistMessage = "Vous êtes blacklist"
var debugMode = true

/// Code ///
const axios = require('axios').default;
//axios.defaults.baseURL = 'https://discord.com/api/v8';
axios.defaults.headers = {
    'Content-Type': 'application/json',
    Authorization: `Bot ${botToken}`
};
function getUserDiscord(source) {
    if(typeof source === 'string') return source;
    if(!GetPlayerName(source)) return false;
    for(let index = 0; index <= GetNumPlayerIdentifiers(source); index ++) {
        if (GetPlayerIdentifier(source, index).indexOf('discord:') !== -1) return GetPlayerIdentifier(source, index).replace('discord:', '');
    }
    return false;
}
on('playerConnecting', (name, setKickReason, deferrals) => {
    let src = global.source;
    deferrals.defer();
    var userId = getUserDiscord(src);

    setTimeout(() => {
        deferrals.update(`Bonjour ${name}. Votre identifiant Discord est en cours de vérification avec notre liste.`)
        setTimeout(async function() {
            if(userId) {
                axios(`/guilds/${guild}/members/${userId}`).then((resDis) => {
                    if(!resDis.data) {
                        if(debugMode) console.log(`'${name}' avec l'id '${userId}' ne peut pas être trouvé dans la guilde assignée et n'a pas été autorisé à y accéder.`);
                        return deferrals.done(noGuildMessage);
                    }
                    const hasRole = typeof whitelistRoles === 'string' ? resDis.data.roles.includes(whitelistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(whitelistRoles[i]));
                    const hasBlackRole = typeof blacklistRoles === 'string' ? resDis.data.roles.includes(blacklistRoles) : resDis.data.roles.some((cRole, i) => resDis.data.roles.includes(blacklistRoles[i]));
                    if(hasBlackRole) {
                        if(debugMode) console.log(`'${name}' avec l'id '${userId}' est sur liste noire pour rejoindre ce serveur.`);
                        return deferrals.done(blacklistMessage);
                    }
                    if(hasRole) {
                        if(debugMode) console.log(`'${name}' avec l'id '${userId}' a obtenu l'accès et a passé la whitelist.`);
                        return deferrals.done();
                    } else {
                        if(debugMode) console.log(`'${name}' avec l'id '${userId}' n'est pas sur la whitelist pour rejoindre ce serveur.`);
                        return deferrals.done(notWhitelistedMessage);
                    }
                }).catch((err) => {
                    if(debugMode) console.log(`^1 Il y a eu un problème avec la demande d'API Discord. L'ID de guilde et le token du bot sont-ils corrects ?^7`);
                });
            } else {
                if(debugMode) console.log(`'${name}' n'a pas obtenu l'accès car un identifiant Discord n'a pas pu être trouvé.`);
                return deferrals.done(`Discord n'a pas été détecté. Veuillez vous assurer que Discord est en cours d'exécution et installé. Voir le lien ci-dessous pour un processus de débug - https://docs.faxes.zone/c/fivem/debugging-discord`);
            }
        }, 0)
    }, 0)
})