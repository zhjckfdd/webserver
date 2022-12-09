create table users(
  id serial primary key,
  name text not null,
  login text not null,
  password text not null,
  date_of_creation timestamp with time zone not null default CURRENT_TIMESTAMP,
  is_admin bool not null default false,
  is_creator bool not null default false);

create table categories(
  id serial primary key,
  category_name text not null);

create table news(                                                                      
  id serial primary key,                                                                    
  shorttitle text not null,
  date_of_creation timestamp with time zone not null default CURRENT_TIMESTAMP,
  creatornews integer not null references users (id) on delete cascade,
  category integer not null references categories (id) on delete cascade,
  content text not null,
  photo integer,
  publishednews bool not null);
