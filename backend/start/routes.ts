/*
|--------------------------------------------------------------------------
| Routes file
|--------------------------------------------------------------------------
|
| The routes file is used for defining the HTTP routes.
|
*/

import router from "@adonisjs/core/services/router";
import { middleware } from "./kernel.js";

const UsersController = () => import("#controllers/users_controller");
const SessionController = () => import("#controllers/session_controller");

// start/routes.ts

router.resource("session", SessionController);

router.resource("users", UsersController).use("*", middleware.auth());

router.ws("/room/:roomId", ({ ws, params, auth }) => {
	// const roomId = params.roomId
	// const user = auth.user

	ws.on("message", (message) => {
		ws.broadcast(`Someone said:  + ${message.toString()}`);
	});

	ws.on("close", () => {
		console.log("Connection closed");
	});

	ws.send(`Hello! Your id is ${ws.id}`);
});
