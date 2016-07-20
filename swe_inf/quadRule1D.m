% This file is part of FESTUNG 
% Copyright (C) 2014 Florian Frank, Balthasar Reuter, Vadym Aizinger
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
function [Q, W] = quadRule1D(qOrd)
switch qOrd
  case {0, 1} % R = 1, number of quadrature points
    Q = 0;
    W = 2;
  case {2, 3} % R = 2
    Q = sqrt(1/3)*[-1, 1];
    W = [1, 1];
  case {4, 5} % R = 3
    Q = sqrt(3/5)*[-1, 0, 1];
    W = 1/9*[5, 8, 5];
  case {6, 7} % R = 4
    Q = [-1,-1,1,1].*sqrt(3/7+[1,-1,-1,1]*2/7*sqrt(6/5));
    W = 1/36*(18 + sqrt(30)*[-1,1,1,-1]);
  case {8, 9} % R = 5
    Q = [-1,-1,0,1,1].*sqrt(5+[2,-2,0,-2,2]*sqrt(10/7))/3;
    W = 1/900*(322+13*sqrt(70)*[-1,1,0,1,-1]+[0,0,190,0,0]);
  case {10, 11} % R = 6
    Q = [ 0.6612093864662645, -0.6612093864662645, -0.2386191860831969, ...
          0.2386191860831969, -0.9324695142031521,  0.9324695142031521];
    W = [ 0.3607615730481386,  0.3607615730481386,  0.4679139345726910, ...
          0.4679139345726910,  0.1713244923791704,  0.171324492379170];
  case {12, 13} % R = 7
    Q = [ 0.0000000000000000,  0.4058451513773972, -0.4058451513773972, ...
         -0.7415311855993945,  0.7415311855993945, -0.9491079123427585, ...
          0.9491079123427585];
    W = [ 0.4179591836734694,  0.3818300505051189,  0.3818300505051189, ...
          0.2797053914892766,  0.2797053914892766,  0.1294849661688697, ...
          0.1294849661688697];	
  case {14, 15} % R = 8
    Q = [-0.1834346424956498,  0.1834346424956498, -0.5255324099163290, ...
          0.5255324099163290, -0.7966664774136267,  0.7966664774136267, ...
         -0.9602898564975363,  0.9602898564975363]; 
    W = [ 0.3626837833783620,  0.3626837833783620,  0.3137066458778873, ...
          0.3137066458778873,  0.2223810344533745,  0.2223810344533745, ...
          0.1012285362903763,  0.1012285362903763];
  case {16, 17} % R = 9
    Q = [ 0.0000000000000000, -0.8360311073266358,  0.8360311073266358, ...
         -0.9681602395076261,  0.9681602395076261, -0.3242534234038089, ...
          0.3242534234038089, -0.6133714327005904,  0.6133714327005904];
    W = [ 0.3302393550012598,  0.1806481606948574,  0.1806481606948574, ...
          0.0812743883615744,  0.0812743883615744,  0.3123470770400029, ...
          0.3123470770400029,  0.2606106964029354,  0.2606106964029354];
  case {28, 29} % R = 15 <----------neu!!! https://pomax.github.io/bezierinfo/legendre-gauss.html
    Q = [ 0.0000000000000000, -0.2011940939974345,  0.2011940939974345, ...
         -0.3941513470775634,  0.3941513470775634, -0.5709721726085388, ...
          0.5709721726085388, -0.7244177313601701,  0.7244177313601701, ...
         -0.8482065834104272,  0.8482065834104272, -0.9372733924007060, ...
          0.9372733924007060, -0.9879925180204854,  0.9879925180204854];
    W = [ 0.2025782419255613,  0.1984314853271116,  0.1984314853271116, ...
          0.1861610000155622,  0.1861610000155622,  0.1662692058169939, ...
          0.1662692058169939,  0.1395706779261543,  0.1395706779261543, ...
          0.1071592204671719,  0.1071592204671719,  0.0703660474881081, ...
          0.0703660474881081,  0.0307532419961173,  0.0307532419961173];
  case {62,63} % R = 32
    Q = [-0.0483076656877383,  0.0483076656877383, -0.1444719615827965, ...
          0.1444719615827965, -0.2392873622521371,  0.2392873622521371, ...
         -0.3318686022821277,  0.3318686022821277, -0.4213512761306353, ...
          0.4213512761306353, -0.5068999089322294,  0.5068999089322294, ...
         -0.5877157572407623,  0.5877157572407623, -0.6630442669302152, ...
          0.6630442669302152, -0.7321821187402897,  0.7321821187402897, ...
         -0.7944837959679424,  0.7944837959679424, -0.8493676137325700, ...
          0.8493676137325700, -0.8963211557660521,  0.8963211557660521, ...
         -0.9349060759377397,  0.9349060759377397, -0.9647622555875064, ...
          0.9647622555875064, -0.9856115115452684,  0.9856115115452684, ...
         -0.9972638618494816,  0.9972638618494816];
    W = [ 0.0965400885147278,  0.0965400885147278,  0.0956387200792749, ...
          0.0956387200792749,  0.0938443990808046,  0.0938443990808046, ...
          0.0911738786957639,  0.0911738786957639,  0.0876520930044038, ...
          0.0876520930044038,  0.0833119242269467,  0.0833119242269467, ...
          0.0781938957870703,  0.0781938957870703,  0.0723457941088485, ...
          0.0723457941088485,  0.0658222227763618,  0.0658222227763618, ...
          0.0586840934785355,  0.0586840934785355,  0.0509980592623762, ...
          0.0509980592623762,  0.0428358980222267,  0.0428358980222267, ...
          0.0342738629130214,  0.0342738629130214,  0.0253920653092621, ...
          0.0253920653092621,  0.0162743947309057,  0.0162743947309057, ...
          0.0070186100094701,  0.0070186100094701];
  case {126, 127} % R = 64     
    Q = [-0.0243502926634244,  0.0243502926634244, -0.0729931217877990, ...
          0.0729931217877990, -0.1214628192961206,  0.1214628192961206, ...
         -0.1696444204239928,  0.1696444204239928, -0.2174236437400071, ...
          0.2174236437400071, -0.2646871622087671,  0.2646871622087674, ...
         -0.3113228719902110,  0.3113228719902110, -0.3572201583376681, ...
          0.3572201583376681, -0.4022701579639916,  0.4022701579639916, ...
         -0.4463660172534641,  0.4463660172534641, -0.4894031457070530, ...
          0.4894031457070530, -0.5312794640198946,  0.5312794640198946, ...
         -0.5718956462026340,  0.5718956462026340, -0.6111553551723933, ...
          0.6111553551723933, -0.6489654712546573,  0.6489654712546573, ...
         -0.6852363130542333,  0.6852363130542333, -0.7198818501716109, ...
          0.7198818501716109, -0.7528199072605319,  0.7528199072605319, ...
         -0.7839723589433414,  0.7839723589433414, -0.8132653151227975, ...
          0.8132653151227975, -0.8406292962525803,  0.8406292962525803, ...
         -0.8659993981540928,  0.8659993981540928, -0.8893154459951141, ...
          0.8893154459951141, -0.9105221370785028,  0.9105221370785028, ...
         -0.9295691721319396,  0.9295691721319396, -0.9464113748584028, ...
          0.9464113748584028, -0.9610087996520538,  0.9610087996520538, ...
         -0.9733268277899110,  0.9733268277899110, -0.9833362538846260, ...
          0.9833362538846260, -0.9910133714767443,  0.9910133714767443, ...
         -0.9963401167719553,  0.9963401167719553, -0.9993050417357722, ...
          0.9993050417357722];    
    W = [ 0.0486909570091397,  0.0486909570091397,  0.0485754674415034, ...
          0.0485754674415034,  0.0483447622348030,  0.0483447622348030, ...
          0.0479993885964583,  0.0479993885964583,  0.0475401657148303, ...
          0.0475401657148303,  0.0469681828162100,  0.0469681828162100, ...
          0.0462847965813144,  0.0462847965813144,  0.0454916279274181, ...
          0.0454916279274181,  0.0445905581637566,  0.0445905581637566, ...
          0.0435837245293235,  0.0435837245293235,  0.0424735151236536, ...
          0.0424735151236536,  0.0412625632426235,  0.0412625632426235, ...
          0.0399537411327203,  0.0399537411327203,  0.0385501531786156, ...
          0.0385501531786156,  0.0370551285402400,  0.0370551285402400, ...
          0.0354722132568824,  0.0354722132568824,  0.0338051618371416, ...
          0.0338051618371416,  0.0320579283548516,  0.0320579283548516, ...
          0.0302346570724025,  0.0302346570724025,  0.0283396726142595, ...
          0.0283396726142595,  0.0263774697150547,  0.0263774697150547, ...
          0.0243527025687109,  0.0243527025687109,  0.0222701738083833, ...
          0.0222701738083833,  0.0201348231535302,  0.0201348231535302, ...
          0.0179517157756973,  0.0179517157756973,  0.0157260304760247, ...
          0.0157260304760247,  0.0134630478967186,  0.0134630478967186, ...
          0.0111681394601311,  0.0111681394601311,  0.0088467598263639, ...
          0.0088467598263639,  0.0065044579689784,  0.0065044579689784, ...
          0.0041470332605625,  0.0041470332605625,  0.0017832807216964, ...
          0.0017832807216964];
          
end % switch
Q = (Q + 1)/2;  W = W/2; % transformation [-1; 1] -> [0, 1]
end % function
