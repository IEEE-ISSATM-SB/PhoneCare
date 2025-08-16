import { Injectable, UnauthorizedException, BadRequestException, InternalServerErrorException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { UsersService } from '../users/users.service';
import * as bcrypt from 'bcrypt';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';

@Injectable()
export class AuthService {
	constructor(
		private readonly usersService: UsersService,
		private readonly jwtService: JwtService,
	) {}

	async register(registerDto: RegisterDto) {
		try {
			console.log('🔐 Registration attempt:', { email: registerDto.email, name: registerDto.name });
			
			const { email, password, name } = registerDto;
			const existingUser = await this.usersService.findByEmail(email);
			if (existingUser) {
				throw new BadRequestException('Email already in use');
			}
			
			console.log('🔐 Hashing password...');
			const hashedPassword = await bcrypt.hash(password, 10);
			
			console.log('🔐 Creating user...');
			const user = await this.usersService.createUser(email, hashedPassword, name);
			
			console.log('✅ User registered successfully:', { email: user.email, name: user.name });
			return { email: user.email, name: user.name };
		} catch (error) {
			if (error instanceof BadRequestException) {
				throw error;
			}
			console.error('❌ Registration error:', error);
			throw new InternalServerErrorException('Failed to register user. Please try again.');
		}
	}

	async login(loginDto: LoginDto) {
		try {
			console.log('🔐 Login attempt:', { email: loginDto.email });
			
			const { email, password } = loginDto;
			
			// Validate input
			if (!email || !password) {
				throw new BadRequestException('Email and password are required');
			}
			
			console.log('🔐 Finding user by email...');
			const user = await this.usersService.findByEmail(email);
			if (!user) {
				console.log('❌ User not found:', email);
				throw new UnauthorizedException('Invalid credentials');
			}
			
			console.log('🔐 User found, comparing password...');
			const isPasswordValid = await bcrypt.compare(password, user.password);
			if (!isPasswordValid) {
				console.log('❌ Invalid password for user:', email);
				throw new UnauthorizedException('Invalid credentials');
			}
			
			console.log('🔐 Password valid, generating JWT...');
			const payload = { sub: user._id, email: user.email };
			const token = this.jwtService.sign(payload);
			
			console.log('✅ User logged in successfully:', { email: user.email, userId: user._id });
			return { access_token: token };
		} catch (error) {
			if (error instanceof UnauthorizedException || error instanceof BadRequestException) {
				throw error;
			}
			console.error('❌ Login error:', error);
			console.error('❌ Error stack:', error.stack);
			throw new InternalServerErrorException('Failed to authenticate. Please try again.');
		}
	}
}
