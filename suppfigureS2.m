%This .m file generates Supplementary Figure S2 from the paper 'The 
%effectiveness of social bubbles as part of a Covid-19 lockdown exit 
%strategy, a modelling study'

%base parameters
Runs = 1;
eps = 1.49;
tauH = 0.64;
tauB = [tauH 0.5*tauH 0.1*tauH];
%Death probability
Death_Prop = [0.00161,0.00695,0.0309,0.0844,0.161,0.595,1.93,4.28,7.8]./100;

RelInf = [0.5 0.5 1 1 1 1 1 1 1];
RelTrans = ones(1,9);

load('PaperHouseholdworkspace.mat');

for j = 1:Runs
  tic  
  for i = 1:21
        Bs = BubbleNonCompliance(B, 0, (i-1)*0.05);
            
        NewH = PruneMatrixFull(H, tauH, 'H',  Age, RelTrans, RelInf);
        NewB1 = PruneMatrixFull(Bs, tauB(1), 'B', Age, RelTrans, RelInf);
        NewB2 = PruneMatrixFull(Bs, tauB(2), 'B', Age, RelTrans, RelInf);
        NewB3 = PruneMatrixFull(Bs, tauB(3), 'B', Age, RelTrans, RelInf);
        
        NewM1 = NewH + NewB1;
        NewM2 = NewH + NewB2;
        NewM3 = NewH + NewB3;
        
        %tauB = tauH
        [~, RSize, Rgen, ~, Deaths] = InfectionProcessFull(NewM1, eps, C, 100,Age,RelTrans,RelInf, Death_Prop);
        R1(j,i) = RSize;        
        Check1(j,i) = abs(Rgen(5) - Rgen(4))/Rgen(4);       
        D1(j,i) = Deaths/length(NewM1);
      
        %tauB = 0.5*tauH
        [~, RSize, Rgen, ~, Deaths] = InfectionProcessFull(NewM2, eps, C, 100,Age,RelTrans,RelInf, Death_Prop);
        R2(j,i) = RSize;        
        Check2(j,i) = abs(Rgen(5) - Rgen(4))/Rgen(4);       
        D2(j,i) = Deaths/length(NewM2);
               
        %tauB = 0.1*tauH
        [~, RSize, Rgen, ~, Deaths] = InfectionProcessFull(NewM3, eps, C, 100,Age,RelTrans,RelInf, Death_Prop);
        R3(j,i) = RSize;        
        Check3(j,i) = abs(Rgen(5) - Rgen(4))/Rgen(4);       
        D3(j,i) = Deaths/length(NewM3);
          
        i
        j
  end
  toc
end

%Average over runs 
if Runs == 1
    D1mean = D1/D1(:,1);
    D2mean = D2/D2(:,1);
    D3mean = D3/D3(:,1);
    
    R1mean = R1;
    R2mean = R2;
    R3mean = R3;
else
    D1mean = mean(D1)/mean(D1(:,1));
    D2mean = mean(D2)/mean(D2(:,1));
    D3mean = mean(D3)/mean(D3(:,1));

    R1mean = mean(R1);
    R2mean = mean(R2);
    R3mean = mean(R3);
end

%Plot Left Figure
figure;
plot(5*(0:20), R1mean); hold on
plot(5*(0:20), R2mean); hold on
plot(5*(0:20), R3mean); hold on
xlabel('% of households in bubbles');
ylabel('R');

%Plot Right Figure
figure;
plot(5*(0:20), D1mean); hold on
plot(5*(0:20), D2mean); hold on
plot(5*(0:20), D3mean); hold on
xlabel('% of households in bubbles');
ylabel('Increase in fatalities');