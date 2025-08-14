import { Controller, Post, Body, Get, Req, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Controller('auth')
export class AuthController {
	constructor(private readonly authService: AuthService) {}

	@Post('register')
	async register(@Body() registerDto: RegisterDto) {
		return this.authService.register(registerDto);
	}

	@Post('login')
	async login(@Body() loginDto: LoginDto) {
		return this.authService.login(loginDto);
	}

	@Get('google')
	@UseGuards(AuthGuard('google'))
	googleAuth() {
		// Google OAuth2 login redirect
		return;
	}

	@Get('google/callback')
	@UseGuards(AuthGuard('google'))
	googleAuthRedirect(@Req() req) {
		// Handle Google OAuth2 callback and return JWT or user info
		return req.user;
	}
}
