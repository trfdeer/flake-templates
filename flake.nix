{
  outputs = { self }: {
    templates = {
      default = {
        path = ./templates/default;
        description = "basic template";
      };
    };
  };

}
