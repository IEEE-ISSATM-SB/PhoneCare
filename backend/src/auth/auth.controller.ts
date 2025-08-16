import { Controller, Post, Body, Get, Req, UseGuards, BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { RequestResetDto } from './dto/request-reset.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { UsersService } from '../users/users.service';

@Controller('auth')
export class AuthController {
	constructor(
		private readonly authService: AuthService,
		private readonly usersService: UsersService
	) {}

	@Post('request-reset')
	async requestReset(@Body() dto: RequestResetDto) {
		try {
			console.log('🔄 Password reset request:', { email: dto.email });
			const otp = await this.usersService.generateOtp(dto.email);
			if (!otp) throw new BadRequestException('Email not found');
			// TODO: Send OTP to email (use a mail service here)
			console.log('✅ OTP generated successfully for:', dto.email);
			return { message: 'OTP sent to email' };
		} catch (error) {
			console.error('❌ Password reset request error:', error);
			if (error instanceof BadRequestException) {
				throw error;
			}
			throw new InternalServerErrorException('Failed to process password reset request');
		}
	}

	@Post('reset-password')
	async resetPassword(@Body() dto: ResetPasswordDto) {
		try {
			console.log('🔄 Password reset attempt:', { email: dto.email });
			const success = await this.usersService.verifyOtpAndResetPassword(dto);
			if (!success) throw new BadRequestException('Invalid OTP or expired');
			console.log('✅ Password reset successful for:', dto.email);
			return { message: 'Password reset successful' };
		} catch (error) {
			console.error('❌ Password reset error:', error);
			if (error instanceof BadRequestException) {
				throw error;
			}
			throw new InternalServerErrorException('Failed to reset password');
		}
	}

	@Post('register')
	async register(@Body() registerDto: RegisterDto) {
		try {
			console.log('🔄 Registration request received:', { 
				email: registerDto.email, 
				name: registerDto.name,
				hasPassword: !!registerDto.password,
				dtoType: typeof registerDto,
				dtoKeys: Object.keys(registerDto),
				rawBody: JSON.stringify(registerDto)
			});
			
			const result = await this.authService.register(registerDto);
			console.log('✅ Registration successful:', result);
			return result;
		} catch (error) {
			console.error('❌ Registration error in controller:', error);
			console.error('❌ Error details:', {
				message: error.message,
				statusCode: error.statusCode,
				stack: error.stack,
				dto: registerDto
			});
			throw error; // Re-throw to let the service handle it
		}
	}

	@Post('login')
	async login(@Body() loginDto: LoginDto) {
		try {
			console.log('🔄 Login request received:', { email: loginDto.email });
			
			// Validate input manually as backup
			if (!loginDto.email || !loginDto.password) {
				throw new BadRequestException('Email and password are required');
			}
			
			const result = await this.authService.login(loginDto);
			console.log('✅ Login successful for:', loginDto.email);
			return result;
		} catch (error) {
			console.error('❌ Login error in controller:', error);
			console.error('❌ Error details:', {
				message: error.message,
				statusCode: error.statusCode,
				stack: error.stack
			});
			
			// Re-throw the error to maintain proper error handling
			throw error;
		}
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
