printf("element,B (bouyancy),H1(length) ,H2(width) ,H3(diam) ,H4(0=other 1=wire 2=fastner),Cd (drag),ME (elasticity)\n");
for i=1:length(B)
  printf("%s ,%f ,%f ,%f ,%f ,%f ,%f ,%f\n", moorele(i,:), B(i), H(1,i), H(2,i), H(3,i), H(4,i), Cd(i), ME(i));
end