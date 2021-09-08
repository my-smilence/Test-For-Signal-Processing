%% ά���˲�=�۲�ֵ�����/�۲�����ֵ�����
clc
clear
%%
%s=A?sin(2��f1t)+B?sin(2��f2t)
%A=10,B=15,f1=1000,f2 =2000 



%% �źŲ�������ԭʼ�źŽ��в���
A=10;            % �źŵķ�ֵ
B=15;            % �źŵķ�ֵ
f1=1000;      % �ź�1��Ƶ��
f2=2000;      % �ź�2��Ƶ��
fs=10^5;    % ����Ƶ��
t=0:999;  % ������t = [0,999],����1000
M = length(t);  % �źų���
s=A*sin(2*pi*f1*t/fs) + B*sin(2*pi*f2*t/fs); % �������Ҳ��ź�ΪSignal ��ֵ�ź�
SNR = 3; % ��ʼ�����
x=awgn(s,SNR,'measured'); %�۲��ź� x=s+v.�������Ҳ��źż��������Ϊ-3dB�ĸ�˹������
v=x - s; % ��˹������������źţ�ÿ�����ж���һ��
%% ��һ��������������ź�d(n)Ϊ����Ȥ��ԭ�ź�Signal
d = s; 
%% �ڶ���������������ź�d(n)ΪNoise  v
% d = v; 
%% ������������� �����ź�d(n)Ϊx(n-1)
% d = [x(1),x(1:end-1),]; % d(n)=x(n-1)

%% ά���˲�
N = floor(length(x)*0.1);  % �˲����Ľ���������ȡ��
% N=100; % ά���˲�������
Rxx=xcorr(x,N-1,'biased'); % ����غ���1*(2N-1)ά�ȣ�����һ���ӳٷ�Χ��[-N��N]�Ļ���غ�������,�ԳƵ�
%N=100  �޶���������г���// 2*100-1=199��
%Rxx=1x199 ,�˴�Ϊx�����������  
%M*N ���� ��2M-1��*N^2

% ��ɾ��� N*Nά��
for i=1:N
    for j=1:N
        mRxx(i,j)=Rxx(N-i+j); % N*Nά��
    end
end

%����ά���˲���x �����Ϲ۲��ź��������ź�d�Ļ���ؾ���
Rxd=xcorr(x,d,N-1,'biased'); % ����غ���1*(2N-1)ά��


% ��ɾ���1*Nά��
for i=1:N
    mRxd(i)=Rxd(N-1+i); % 1*Nά��
end

h = inv(mRxx)*mRxd'; % ��wiener-Hopf���̵õ��˲������Ž�, h��N*1ά��

%% ����wiener�˲�Ч��
y = conv(x,h); % �˲�������,����ΪM+N-1��Ҫ��ȡǰM����
y = y(1:M); % yy = filter(h,1,x);  % �þ�������ֱ����filter������
Py=sum(power(y,2))/M; %�˲����ź�y�Ĺ���
e = d - y;  % �����ȥ���������˲����
J = sum(power(e,2))/M % �˲�����������
SNR_after = 10*log10((Py-J)/J) % �˲�������� db��λ
imv = 10*log10((Py-J)/J/power(10,SNR/10)) % �˲�����˲�ǰ����������imv dB��

%%  ��ͼ
% ԭʼ�ź�x������v���۲Ⲩ��d
figure(1), subplot(311)
plot(t,s) % ���뺯��
title(' Signalԭ�ź�')

subplot(312)
plot(t,v) % ���뺯��
title(' Noise����')

subplot(313)
plot(t,x) % ���뺯��
title(' X(n)�۲Ⲩ��')

%% d = s
% �������˲�����źŶԱ�
figure(2), subplot(211)
plot(t, d, 'r:', t, y, 'b-','LineWidth',1);
legend('�����ź�','�˲�����'); title('�����ź����˲�����Ա�');
xlabel('�۲����');ylabel('�źŷ���');
axis([0 1000 -50 50])

subplot(212), plot(t, e);
title('������');
xlabel('�۲����');ylabel('������');
axis([0 1000 -50 50])

% �˲�ǰ��Ա�
figure(3), subplot(211)
plot(t, x);
title('ά���˲�ǰ');
xlabel('�۲����');ylabel('�źŷ���');
axis([0 1000 -50 50])

subplot(212), plot(t, y);
title('ά���˲���');
xlabel('�۲����');ylabel('������');
axis([0 1000 -50 50])




